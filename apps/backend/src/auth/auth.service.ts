import {
  Injectable,
  UnauthorizedException,
  ConflictException,
  BadRequestException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class AuthService {
  constructor(
    private prisma: PrismaService,
    private jwtService: JwtService,
  ) {}

  async register(registerDto: any) {
    if (!registerDto) {
      throw new BadRequestException('Request body is required');
    }

    const {
      email,
      password,
      fullName,
      passportNumber,
      countryOfOrigin,
      phoneNumber,
    } = registerDto;

    if (!email || !password) {
      throw new BadRequestException('Email and password are required');
    }

    const existingUser = await this.prisma.user.findUnique({
      where: { email },
    });

    if (existingUser) {
      throw new ConflictException('User already exists');
    }

    const hashedPassword = await bcrypt.hash(password, 12);

    const user = await this.prisma.user.create({
      data: {
        email,
        password: hashedPassword,
        fullName: fullName ?? email,
        passportNumber: passportNumber ?? '',
        countryOfOrigin: countryOfOrigin ?? '',
        phoneNumber: phoneNumber ?? '',
        role: 'student',
        isActive: true,
      },
    });

    const tokens = await this.generateTokens(user.id, user.email);

    return {
      user: this.mapUser(user),
      ...tokens,
    };
  }

  async login(loginDto: any) {
    if (!loginDto) {
      throw new BadRequestException('Request body is required');
    }

    const identifier = loginDto.email ?? loginDto.username;
    const password = loginDto.password;

    if (!identifier || !password) {
      throw new BadRequestException('Email/username and password are required');
    }

    const user = await this.prisma.user.findFirst({
      where: {
        OR: [
          { email: identifier },
          { email: `${identifier}@local.test` },
        ],
      },
    });

    if (user) {
      const isPasswordValid = await bcrypt.compare(password, user.password);

      if (!isPasswordValid) {
        throw new UnauthorizedException('Invalid credentials');
      }

      if (!user.isActive) {
        throw new UnauthorizedException('Account is disabled');
      }

      const tokens = await this.generateTokens(user.id, user.email);

      return {
        user: this.mapUser(user),
        ...tokens,
      };
    }

    const adminUser = await this.prisma.adminUser.findFirst({
      where: {
        OR: [
          { username: identifier },
          { email: identifier },
        ],
      },
    });

    if (!adminUser) {
      throw new UnauthorizedException('Invalid credentials');
    }

    const isBcryptPassword =
      adminUser.password.startsWith('$2a$') ||
      adminUser.password.startsWith('$2b$') ||
      adminUser.password.startsWith('$2y$');

    const isPasswordValid = isBcryptPassword
      ? await bcrypt.compare(password, adminUser.password)
      : password === adminUser.password;

    if (!isPasswordValid) {
      throw new UnauthorizedException('Invalid credentials');
    }

    if (adminUser.isLocked || !adminUser.isActive) {
      throw new UnauthorizedException('Account is disabled');
    }

    const tokenEmail = adminUser.email ?? `${adminUser.username}@local.test`;

    const tokens = await this.generateTokens(adminUser.id, tokenEmail);

    return {
      user: {
        id: adminUser.id,
        username: adminUser.username,
        email: adminUser.email,
        displayName: adminUser.fullName,
        fullName: adminUser.fullName,
        role: adminUser.role,
        unitKey: adminUser.unit ?? 'education',
        unit: adminUser.unit,
        isLocked: adminUser.isLocked,
        passportNo: adminUser.passportNo,
        studentNo: adminUser.studentNo,
        phone: adminUser.phone,
      },
      ...tokens,
    };
  }

  async refreshTokens(refreshToken: string) {
    if (!refreshToken) {
      throw new BadRequestException('Refresh token is required');
    }

    try {
      const payload = this.jwtService.verify(refreshToken, {
        secret: process.env.JWT_REFRESH_SECRET,
      });

      const user = await this.prisma.user.findUnique({
        where: { id: payload.sub },
      });

      if (user && user.isActive) {
        return this.generateTokens(user.id, user.email);
      }

      const adminUser = await this.prisma.adminUser.findUnique({
        where: { id: payload.sub },
      });

      if (!adminUser || adminUser.isLocked || !adminUser.isActive) {
        throw new UnauthorizedException('Invalid refresh token');
      }

      return this.generateTokens(
        adminUser.id,
        adminUser.email ?? `${adminUser.username}@local.test`,
      );
    } catch {
      throw new UnauthorizedException('Invalid refresh token');
    }
  }

  private mapUser(user: any) {
    const username = user.email.includes('@')
      ? user.email.split('@')[0]
      : user.email;

    return {
      id: user.id,
      username,
      email: user.email,
      displayName: user.fullName,
      fullName: user.fullName,
      role: user.role,
      unitKey: user.unitKey ?? 'education',
      isLocked: user.isActive === false,
      countryOfOrigin: user.countryOfOrigin,
    };
  }

  private async generateTokens(userId: string, email: string) {
    const [accessToken, refreshToken] = await Promise.all([
      this.jwtService.signAsync(
        { sub: userId, email },
        {
          secret: process.env.JWT_SECRET,
          expiresIn: '15m',
        },
      ),
      this.jwtService.signAsync(
        { sub: userId, email },
        {
          secret: process.env.JWT_REFRESH_SECRET,
          expiresIn: '7d',
        },
      ),
    ]);

    return {
      accessToken,
      refreshToken,
      expiresIn: 900,
    };
  }
}
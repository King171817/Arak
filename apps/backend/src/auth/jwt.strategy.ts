import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor(private prisma: PrismaService) {
    const secret = process.env.JWT_SECRET;
    
    console.log('JWT Strategy - Secret loaded:', secret ? '✅ Yes' : '❌ No');
    
    if (!secret) {
      throw new Error('JWT_SECRET is not defined. Please check your .env file');
    }
    
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: secret,
    });
  }

  async validate(payload: any) {
    const user = await this.prisma.user.findUnique({
      where: { id: payload.sub },
    });

    if (!user) throw new UnauthorizedException('User no longer exists');
    if (!user.isActive) throw new UnauthorizedException('Account disabled');

    return {
      id: user.id,
      email: user.email,
      fullName: user.fullName,
      role: user.role,
      countryOfOrigin: user.countryOfOrigin,
    };
  }
}
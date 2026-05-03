import { BadRequestException, Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class RequestService {
  constructor(private prisma: PrismaService) {}

  async getUserRequests(userId: string) {
    if (!userId) {
      throw new BadRequestException('User id is required');
    }

    const data = await this.prisma.serviceRequest.findMany({
      where: { userId },
      orderBy: { createdAt: 'desc' },
    });

    return { success: true, data };
  }

  async createRequest(userId: string, body: any) {
    if (!userId) {
      throw new BadRequestException('User id is required');
    }

    if (!body) {
      throw new BadRequestException('Request body is required');
    }

    if (!body.type) {
      throw new BadRequestException('type is required');
    }

    const requestNumber = `ZGT-${Date.now()}-${Math.floor(1000 + Math.random() * 9000)}`;

    const data = await this.prisma.serviceRequest.create({
      data: {
        requestNumber,
        userId,
        type: body.type,
        status: 'pending',
        priority: body.priority || 'normal',
        details: JSON.stringify(body.details || {}),
      },
    });

    return { success: true, data };
  }
}

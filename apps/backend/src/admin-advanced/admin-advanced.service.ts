import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class AdminAdvancedService {
  constructor(private prisma: PrismaService) {}

  async createFloatingMessage(data: any) {
    return this.prisma.floatingMessage.create({
      data: {
        textFa: data.textFa ?? '',
        textEn: data.textEn ?? '',
        textAr: data.textAr ?? '',
        startAt: new Date(data.startAt),
        endAt: new Date(data.endAt),
        roles: JSON.stringify(data.roles ?? []),
        units: JSON.stringify(data.units ?? []),
        userIds: JSON.stringify(data.userIds ?? []),
        isActive: data.isActive ?? true,
      },
    });
  }

  async getActiveMessages() {
    const now = new Date();

    const items = await this.prisma.floatingMessage.findMany({
      where: {
        isActive: true,
        startAt: { lte: now },
        endAt: { gte: now },
      },
      orderBy: { createdAt: 'desc' },
    });

    return items.map((item) => ({
      ...item,
      roles: JSON.parse(item.roles || '[]'),
      units: JSON.parse(item.units || '[]'),
      userIds: JSON.parse(item.userIds || '[]'),
    }));
  }

  async deactivateMessage(id: string) {
    return this.prisma.floatingMessage.update({
      where: { id },
      data: { isActive: false },
    });
  }
}

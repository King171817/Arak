import { BadRequestException, ForbiddenException, Injectable, NotFoundException } from '@nestjs/common';
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

    return items.map((item: any) => ({
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

  async saveDatasetSetting(data: any) {
    const existing = await this.prisma.datasetSetting.findFirst({
      orderBy: { createdAt: 'desc' },
    });

    const payload = {
      apiBaseUrl: data.apiBaseUrl ?? '',
      databaseUrl: data.databaseUrl ?? '',
      useApi: data.useApi ?? true,
      useMock: data.useMock ?? true,
      updatedBy: data.updatedBy ?? 'main-admin',
    };

    if (existing) {
      return this.prisma.datasetSetting.update({
        where: { id: existing.id },
        data: payload,
      });
    }

    return this.prisma.datasetSetting.create({ data: payload });
  }

  async getDatasetSetting() {
    const setting = await this.prisma.datasetSetting.findFirst({
      orderBy: { createdAt: 'desc' },
    });

    return setting ?? {
      apiBaseUrl: 'http://localhost:3001',
      databaseUrl: '',
      useApi: true,
      useMock: true,
      updatedBy: '',
    };
  }

  async saveAccessRule(data: any) {
    if (!data.userId) {
      throw new BadRequestException('userId is required');
    }

    const existing = await this.prisma.accessRule.findFirst({
      where: { userId: data.userId },
    });

    const payload = {
      userId: data.userId,
      role: data.role ?? 'student',
      unit: data.unit ?? '',
      permissions: JSON.stringify(data.permissions ?? []),
      isLocked: data.isLocked ?? false,
      updatedBy: data.updatedBy ?? 'main-admin',
    };

    if (existing) {
      return this.prisma.accessRule.update({
        where: { id: existing.id },
        data: payload,
      });
    }

    return this.prisma.accessRule.create({ data: payload });
  }

  async getAccessRules() {
    const items = await this.prisma.accessRule.findMany({
      orderBy: { updatedAt: 'desc' },
    });

    return items.map((item: any) => ({
      ...item,
      permissions: JSON.parse(item.permissions || '[]'),
    }));
  }

  async getAccessRuleByUser(userId: string) {
    const item = await this.prisma.accessRule.findFirst({
      where: { userId },
    });

    if (!item) {
      return null;
    }

    return {
      ...item,
      permissions: JSON.parse(item.permissions || '[]'),
    };
  }

  async createDailyReport(data: any) {
    if (!data.userId || !data.title || !data.description) {
      throw new BadRequestException('userId, title and description are required');
    }

    return this.prisma.dailyActivityReport.create({
      data: {
        userId: data.userId,
        userName: data.userName ?? '',
        role: data.role ?? '',
        unit: data.unit ?? '',
        title: data.title,
        description: data.description,
      },
    });
  }

  async getDailyReports() {
    return this.prisma.dailyActivityReport.findMany({
      orderBy: { createdAt: 'desc' },
    });
  }

  async updateDailyReport(id: string, data: any) {
    const report = await this.prisma.dailyActivityReport.findUnique({
      where: { id },
    });

    if (!report) {
      throw new NotFoundException('Report not found');
    }

    const isMainAdmin = data.isMainAdmin === true;
    const limit = new Date(report.createdAt.getTime() + 48 * 60 * 60 * 1000);

    if (!isMainAdmin && new Date() > limit) {
      throw new ForbiddenException('Edit time expired. Only main admin can edit after 48 hours.');
    }

    return this.prisma.dailyActivityReport.update({
      where: { id },
      data: {
        title: data.title ?? report.title,
        description: data.description ?? report.description,
      },
    });
  }
}

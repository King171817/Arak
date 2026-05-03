import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class AdminService {
  private readonly logger = new Logger(AdminService.name);

  constructor(private prisma: PrismaService) {}

  async getAllUsers() {
    try {
      const users = await this.prisma.user.findMany({
        select: {
          id: true,
          email: true,
          fullName: true,
          role: true,
          isActive: true,
          countryOfOrigin: true,
          createdAt: true,
          _count: {
            select: { requests: true },
          },
        },
      });
      return { success: true, data: users };
    } catch (error) {
      this.logger.error('Error getting users:', error);
      throw error;
    }
  }

  async getAllRequests() {
    try {
      const requests = await this.prisma.serviceRequest.findMany({
        include: {
          user: {
            select: {
              fullName: true,
              email: true,
            },
          },
        },
        orderBy: { createdAt: 'desc' },
      });
      return { success: true, data: requests };
    } catch (error) {
      this.logger.error('Error getting requests:', error);
      throw error;
    }
  }

  async updateRequestStatus(requestId: string, status: string) {
    try {
      const request = await this.prisma.serviceRequest.update({
        where: { id: requestId },
        data: { status },
        include: {
          user: {
            select: {
              fullName: true,
              email: true,
            },
          },
        },
      });
      return { success: true, data: request };
    } catch (error) {
      this.logger.error('Error updating request status:', error);
      throw error;
    }
  }

  async getStats() {
    try {
      const [totalUsers, totalRequests, pendingRequests, completedRequests] = await Promise.all([
        this.prisma.user.count(),
        this.prisma.serviceRequest.count(),
        this.prisma.serviceRequest.count({ where: { status: 'pending' } }),
        this.prisma.serviceRequest.count({ where: { status: 'completed' } }),
      ]);

      return {
        success: true,
        data: {
          totalUsers,
          totalRequests,
          pendingRequests,
          completedRequests,
          completionRate: totalRequests > 0 ? Number((completedRequests / totalRequests * 100).toFixed(2)) : 0,
        },
      };
    } catch (error) {
      this.logger.error('Error getting stats:', error);
      throw error;
    }
  }
}
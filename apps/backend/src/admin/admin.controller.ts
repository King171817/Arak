import { Controller, Get, Put, Param, Body, UseGuards, ForbiddenException } from '@nestjs/common';
import { AdminService } from './admin.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { GetUser } from '../auth/get-user.decorator';

@Controller('admin')
@UseGuards(JwtAuthGuard)
export class AdminController {
  constructor(private readonly adminService: AdminService) {}

  private checkAdminRole(user: any) {
    console.log('User role:', user?.role);
    if (!user || user.role !== 'admin') {
      throw new ForbiddenException('Access denied. Admin only.');
    }
  }

  @Get('users')
  async getAllUsers(@GetUser() user: any) {
    this.checkAdminRole(user);
    return this.adminService.getAllUsers();
  }

  @Get('requests')
  async getAllRequests(@GetUser() user: any) {
    this.checkAdminRole(user);
    return this.adminService.getAllRequests();
  }

  @Put('requests/:id/status')
  async updateRequestStatus(
    @GetUser() user: any,
    @Param('id') id: string,
    @Body('status') status: string,
  ) {
    this.checkAdminRole(user);
    return this.adminService.updateRequestStatus(id, status);
  }

  @Get('stats')
  async getStats(@GetUser() user: any) {
    this.checkAdminRole(user);
    return this.adminService.getStats();
  }
}
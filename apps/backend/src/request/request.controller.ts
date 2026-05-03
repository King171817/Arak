import { Controller, Get, Post, Body, Req, UseGuards } from '@nestjs/common';
import { RequestService } from './request.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@Controller('requests')
@UseGuards(JwtAuthGuard)
export class RequestController {
  constructor(private readonly requestService: RequestService) {}

  private getUserId(req: any): string {
    return req.user?.sub || req.user?.id || req.user?.userId;
  }

  @Get()
  async getMyRequests(@Req() req: any) {
    return this.requestService.getUserRequests(this.getUserId(req));
  }

  @Post()
  async createRequest(@Req() req: any, @Body() body: any) {
    return this.requestService.createRequest(this.getUserId(req), body);
  }
}

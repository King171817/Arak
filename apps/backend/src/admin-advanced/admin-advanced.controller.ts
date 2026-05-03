import { Body, Controller, Get, Param, Post, Put } from '@nestjs/common';
import { AdminAdvancedService } from './admin-advanced.service';

@Controller('admin-advanced')
export class AdminAdvancedController {
  constructor(private readonly service: AdminAdvancedService) {}

  @Post('floating-message')
  create(@Body() body: Record<string, any>) {
    return this.service.createFloatingMessage(body);
  }

  @Get('floating-message')
  getActive() {
    return this.service.getActiveMessages();
  }

  @Put('floating-message/:id/deactivate')
  deactivate(@Param('id') id: string) {
    return this.service.deactivateMessage(id);
  }
}

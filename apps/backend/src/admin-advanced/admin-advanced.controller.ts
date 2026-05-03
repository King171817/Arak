import { Body, Controller, Get, Param, Post, Put } from '@nestjs/common';
import { AdminAdvancedService } from './admin-advanced.service';

@Controller('admin-advanced')
export class AdminAdvancedController {
  constructor(private readonly service: AdminAdvancedService) {}

  @Post('floating-message')
  createFloatingMessage(@Body() body: Record<string, any>) {
    return this.service.createFloatingMessage(body);
  }

  @Get('floating-message')
  getActiveFloatingMessages() {
    return this.service.getActiveMessages();
  }

  @Put('floating-message/:id/deactivate')
  deactivateFloatingMessage(@Param('id') id: string) {
    return this.service.deactivateMessage(id);
  }

  @Post('dataset-setting')
  saveDatasetSetting(@Body() body: Record<string, any>) {
    return this.service.saveDatasetSetting(body);
  }

  @Get('dataset-setting')
  getDatasetSetting() {
    return this.service.getDatasetSetting();
  }

  @Post('access-rule')
  saveAccessRule(@Body() body: Record<string, any>) {
    return this.service.saveAccessRule(body);
  }

  @Get('access-rule')
  getAccessRules() {
    return this.service.getAccessRules();
  }

  @Get('access-rule/:userId')
  getAccessRuleByUser(@Param('userId') userId: string) {
    return this.service.getAccessRuleByUser(userId);
  }

  @Post('daily-report')
  createDailyReport(@Body() body: Record<string, any>) {
    return this.service.createDailyReport(body);
  }

  @Get('daily-report')
  getDailyReports() {
    return this.service.getDailyReports();
  }

  @Put('daily-report/:id')
  updateDailyReport(
    @Param('id') id: string,
    @Body() body: Record<string, any>,
  ) {
    return this.service.updateDailyReport(id, body);
  }
}

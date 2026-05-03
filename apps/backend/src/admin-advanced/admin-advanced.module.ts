import { Module } from '@nestjs/common';
import { AdminAdvancedController } from './admin-advanced.controller';
import { AdminAdvancedService } from './admin-advanced.service';

@Module({
  controllers: [AdminAdvancedController],
  providers: [AdminAdvancedService]
})
export class AdminAdvancedModule {}

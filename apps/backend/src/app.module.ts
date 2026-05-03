import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { PrismaModule } from './prisma/prisma.module';
import { AuthModule } from './auth/auth.module';
import { RequestModule } from './request/request.module';
import { AdminModule } from './admin/admin.module';
import { AdminAdvancedModule } from './admin-advanced/admin-advanced.module';

@Module({
  imports: [
    require('./admin-advanced/admin-advanced.module').AdminAdvancedModule,
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: '.env',
    }),
    PrismaModule,
    AuthModule,
    RequestModule,
    AdminModule,
    AdminAdvancedModule,
  ],
})
export class AppModule {}

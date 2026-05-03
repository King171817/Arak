import { Module } from '@nestjs/common';
import { AuthModule } from './auth/auth.module';
import { RequestModule } from './request/request.module';
import { PrismaModule } from './prisma/prisma.module';

@Module({
  imports: [
    PrismaModule,  // حتماً اول وارد شود
    AuthModule,
    RequestModule,
  ],
})
export class AppModule {}
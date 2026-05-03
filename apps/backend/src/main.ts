import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import * as dotenv from 'dotenv';
import * as path from 'path';

dotenv.config({ path: path.resolve(process.cwd(), '.env') });

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  
  // فعال کردن CORS
  app.enableCors();
  
  // تنظیم Swagger با تم و انیمیشن
  const config = new DocumentBuilder()
    .setTitle('زیگورات گلوبال - API')
    .setDescription(`
      ## 🌍 پلتفرم مدیریت دانشجویان بین‌المللی
      
      ### قابلیت‌ها:
      - 🔐 **احراز هویت** (ثبت‌نام، ورود، JWT)
      - 📝 **مدیریت درخواست‌ها** (ترجمه، ویزا، مسکن، بانک)
      - 👥 **مدیریت کاربران**
      - 📊 **گزارش‌گیری**
      
      ### روش استفاده:
      1. ابتدا در \`/auth/register\` ثبت‌نام کنید
      2. با \`/auth/login\` وارد شوید و توکن دریافت کنید
      3. توکن را در دکمه **Authorize** پایین صفحه وارد کنید
      4. از API‌های محافظت شده استفاده کنید
    `)
    .setVersion('1.0')
    .setContact('زیگورات', 'https://zigurat.com', 'support@zigurat.com')
    .addBearerAuth(
      {
        type: 'http',
        scheme: 'bearer',
        bearerFormat: 'JWT',
        name: 'JWT',
        description: 'توکن خود را وارد کنید',
        in: 'header',
      },
      'JWT-auth',
    )
    .addTag('auth', 'عملیات احراز هویت')
    .addTag('requests', 'مدیریت درخواست‌ها')
    .addTag('admin', 'پنل مدیریت (فقط ادمین)')
    .build();
  
  const document = SwaggerModule.createDocument(app, config);
  
  // تنظیمات سفارشی Swagger UI با انیمیشن
  SwaggerModule.setup('api/docs', app, document, {
    swaggerOptions: {
      persistAuthorization: true,
      docExpansion: 'list',
      filter: true,
      showExtensions: true,
      showCommonExtensions: true,
      syntaxHighlight: {
        activate: true,
        theme: 'monokai',
      },
    },
    customCss: `
      .swagger-ui .topbar { background-color: #1a1a2e; }
      .swagger-ui .topbar .download-url-wrapper .select-label { color: #fff; }
      .swagger-ui .info .title { color: #1a1a2e; font-weight: bold; }
      .swagger-ui .btn.authorize { background-color: #4CAF50; color: white; }
      .swagger-ui .btn.authorize:hover { background-color: #45a049; }
      @keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }
      .swagger-ui .opblock { animation: fadeIn 0.5s ease-in; }
      .swagger-ui .opblock-summary:hover { background-color: #f5f5f5; transition: all 0.3s ease; }
    `,
    customSiteTitle: 'زیگورات گلوبال - مستندات API',
  });
  
  const port = process.env.PORT || 3000;
  await app.listen(port);
  console.log(`🚀 Server running on http://localhost:${port}`);
  console.log(`📚 Swagger UI: http://localhost:${port}/api/docs`);
}
bootstrap();
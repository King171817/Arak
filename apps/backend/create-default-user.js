const { PrismaClient } = require('@prisma/client');
const bcrypt = require('bcrypt');

const prisma = new PrismaClient();

async function createDefaultUser() {
  try {
    // بررسی وجود کاربر
    let user = await prisma.user.findUnique({
      where: { email: 'admin@arak.ac.ir' }
    });
    
    if (!user) {
      // هش کردن رمز 1234
      const hashedPassword = await bcrypt.hash('1234', 12);
      
      user = await prisma.user.create({
        data: {
          email: 'admin@arak.ac.ir',
          password: hashedPassword,
          fullName: 'مدیر سیستم',
          passportNumber: 'ADMIN001',
          countryOfOrigin: 'IRN',
          phoneNumber: '+989123456789',
          role: 'admin',
          isActive: true,
        },
      });
      console.log(' کاربر ادمین با موفقیت ایجاد شد');
      console.log(' ایمیل: admin@arak.ac.ir');
      console.log(' رمز عبور: 1234');
    } else {
      // بروزرسانی رمز به 1234
      const hashedPassword = await bcrypt.hash('1234', 12);
      user = await prisma.user.update({
        where: { email: 'admin@arak.ac.ir' },
        data: { password: hashedPassword, role: 'admin' }
      });
      console.log(' رمز کاربر ادمین بروزرسانی شد');
      console.log(' ایمیل: admin@arak.ac.ir');
      console.log(' رمز عبور: 1234');
    }
    
    // ایجاد کاربر دانشجو نمونه
    let student = await prisma.user.findUnique({
      where: { email: 'student@arak.ac.ir' }
    });
    
    if (!student) {
      const hashedPassword = await bcrypt.hash('1234', 12);
      student = await prisma.user.create({
        data: {
          email: 'student@arak.ac.ir',
          password: hashedPassword,
          fullName: 'دانشجوی نمونه',
          passportNumber: 'STU001',
          countryOfOrigin: 'IRN',
          phoneNumber: '+989123456788',
          role: 'student',
          isActive: true,
        },
      });
      console.log(' کاربر دانشجو با موفقیت ایجاد شد');
      console.log(' ایمیل: student@arak.ac.ir');
      console.log(' رمز عبور: 1234');
    }
    
  } catch (error) {
    console.error('خطا:', error);
  } finally {
    await prisma.$disconnect();
  }
}

createDefaultUser();

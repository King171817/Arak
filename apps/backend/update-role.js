const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function main() {
  // بررسی کاربر قبل از تغییر
  let user = await prisma.user.findUnique({
    where: { email: 'admin@zigurat.com' }
  });
  
  console.log('Before update - Role:', user?.role);
  
  // تغییر نقش
  user = await prisma.user.update({
    where: { email: 'admin@zigurat.com' },
    data: { role: 'admin' }
  });
  
  console.log('After update - Role:', user.role);
  console.log('✅ Admin role updated successfully!');
}

main()
  .catch(console.error)
  .finally(() => prisma.$disconnect());

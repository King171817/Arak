const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();
async function main() {
  const result = await prisma.user.updateMany({
    where: { email: 'admin@zigurat.com' },
    data: { role: 'admin' }
  });
  console.log(`Updated ${result.count} user(s) to admin role`);
  const user = await prisma.user.findUnique({
    where: { email: 'admin@zigurat.com' }
  });
  console.log(`User: ${user?.email}, Role: ${user?.role}`);
}
main().finally(() => prisma.$disconnect());

const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function main() {
  const admin = await prisma.user.update({
    where: { email: 'admin@zigurat.com' },
    data: { role: 'admin' }
  });
  console.log('User updated:', admin.email, 'role:', admin.role);
}

main()
  .catch(console.error)
  .finally(() => prisma.\());

const { PrismaClient } = require('@prisma/client');
const bcrypt = require('bcrypt');

const prisma = new PrismaClient();

const password = 'Test123456';

const users = [
  { username: 'sina', email: 'sina@zigurat.com', fullName: 'Sina Main Admin', role: 'admin', unitKey: 'main' },

  { username: 'admin1', email: 'admin1@zigurat.com', fullName: 'Manager 1', role: 'admin', unitKey: 'international' },
  { username: 'admin2', email: 'admin2@zigurat.com', fullName: 'Manager 2', role: 'admin', unitKey: 'education' },
  { username: 'admin3', email: 'admin3@zigurat.com', fullName: 'Manager 3', role: 'admin', unitKey: 'student_services' },
  { username: 'admin4', email: 'admin4@zigurat.com', fullName: 'Manager 4', role: 'admin', unitKey: 'consular' },

  { username: 'admin', email: 'admin@zigurat.com', fullName: 'Student Admin Username', role: 'student', unitKey: 'education' },

  { username: 'prof1', email: 'prof1@zigurat.com', fullName: 'Professor 1', role: 'professor', unitKey: 'education' },
  { username: 'prof2', email: 'prof2@zigurat.com', fullName: 'Professor 2', role: 'professor', unitKey: 'education' },

  { username: 'test_student', email: 'test_student@zigurat.com', fullName: 'Test Student', role: 'student', unitKey: 'education', passportNumber: 'P987654321', countryOfOrigin: 'IRN', phoneNumber: '+989123456789' },
];

async function main() {
  const hashedPassword = await bcrypt.hash(password, 12);

  for (const u of users) {
    const existing = await prisma.user.findUnique({
      where: { email: u.email },
    });

    if (existing) {
      await prisma.user.update({
        where: { email: u.email },
        data: {
          password: hashedPassword,
          fullName: u.fullName,
          role: u.role,
          isActive: true,
          passportNumber: u.passportNumber || existing.passportNumber,
          countryOfOrigin: u.countryOfOrigin || 'IRN',
          phoneNumber: u.phoneNumber || existing.phoneNumber,
        },
      });

      console.log(`UPDATED: ${u.username} | ${u.email} | ${u.role}`);
    } else {
      await prisma.user.create({
        data: {
          email: u.email,
          password: hashedPassword,
          fullName: u.fullName,
          passportNumber: u.passportNumber || null,
          countryOfOrigin: u.countryOfOrigin || 'IRN',
          phoneNumber: u.phoneNumber || null,
          role: u.role,
          isActive: true,
        },
      });

      console.log(`CREATED: ${u.username} | ${u.email} | ${u.role}`);
    }
  }

  console.log('\nLOGIN PASSWORD FOR ALL TEST USERS: Test123456');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });

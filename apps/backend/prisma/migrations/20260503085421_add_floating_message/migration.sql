-- CreateTable
CREATE TABLE "FloatingMessage" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "textFa" TEXT NOT NULL,
    "textEn" TEXT NOT NULL,
    "textAr" TEXT NOT NULL,
    "startAt" DATETIME NOT NULL,
    "endAt" DATETIME NOT NULL,
    "roles" TEXT NOT NULL DEFAULT '[]',
    "units" TEXT NOT NULL DEFAULT '[]',
    "userIds" TEXT NOT NULL DEFAULT '[]',
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

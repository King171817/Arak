-- CreateTable
CREATE TABLE "DatasetSetting" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "apiBaseUrl" TEXT NOT NULL DEFAULT '',
    "databaseUrl" TEXT NOT NULL DEFAULT '',
    "useApi" BOOLEAN NOT NULL DEFAULT true,
    "useMock" BOOLEAN NOT NULL DEFAULT true,
    "updatedBy" TEXT NOT NULL DEFAULT '',
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL
);

-- CreateTable
CREATE TABLE "AccessRule" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "userId" TEXT NOT NULL,
    "role" TEXT NOT NULL,
    "unit" TEXT NOT NULL DEFAULT '',
    "permissions" TEXT NOT NULL DEFAULT '[]',
    "isLocked" BOOLEAN NOT NULL DEFAULT false,
    "updatedBy" TEXT NOT NULL DEFAULT '',
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL
);

-- CreateTable
CREATE TABLE "DailyActivityReport" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "userId" TEXT NOT NULL,
    "userName" TEXT NOT NULL,
    "role" TEXT NOT NULL,
    "unit" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL
);

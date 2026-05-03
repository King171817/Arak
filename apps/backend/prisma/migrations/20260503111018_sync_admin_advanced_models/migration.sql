/*
  Warnings:

  - You are about to drop the column `apiBaseUrl` on the `DatasetSetting` table. All the data in the column will be lost.
  - You are about to drop the column `databaseUrl` on the `DatasetSetting` table. All the data in the column will be lost.
  - You are about to drop the column `useApi` on the `DatasetSetting` table. All the data in the column will be lost.
  - You are about to drop the column `useMock` on the `DatasetSetting` table. All the data in the column will be lost.

*/
-- RedefineTables
PRAGMA defer_foreign_keys=ON;
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_AccessRule" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "userId" TEXT NOT NULL,
    "role" TEXT NOT NULL,
    "unit" TEXT,
    "permissions" TEXT NOT NULL,
    "isLocked" BOOLEAN NOT NULL DEFAULT false,
    "updatedBy" TEXT,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME
);
INSERT INTO "new_AccessRule" ("createdAt", "id", "isLocked", "permissions", "role", "unit", "updatedAt", "updatedBy", "userId") SELECT "createdAt", "id", "isLocked", "permissions", "role", "unit", "updatedAt", "updatedBy", "userId" FROM "AccessRule";
DROP TABLE "AccessRule";
ALTER TABLE "new_AccessRule" RENAME TO "AccessRule";
CREATE INDEX "AccessRule_userId_idx" ON "AccessRule"("userId");
CREATE INDEX "AccessRule_role_idx" ON "AccessRule"("role");
CREATE INDEX "AccessRule_unit_idx" ON "AccessRule"("unit");
CREATE TABLE "new_AdminUser" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "username" TEXT NOT NULL,
    "email" TEXT,
    "password" TEXT NOT NULL,
    "fullName" TEXT NOT NULL,
    "role" TEXT NOT NULL DEFAULT 'student',
    "unit" TEXT,
    "passportNo" TEXT,
    "studentNo" TEXT,
    "phone" TEXT,
    "isLocked" BOOLEAN NOT NULL DEFAULT false,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdBy" TEXT,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME
);
INSERT INTO "new_AdminUser" ("createdAt", "email", "fullName", "id", "isLocked", "passportNo", "password", "phone", "role", "studentNo", "unit", "updatedAt", "username") SELECT "createdAt", "email", "fullName", "id", "isLocked", "passportNo", "password", "phone", "role", "studentNo", "unit", "updatedAt", "username" FROM "AdminUser";
DROP TABLE "AdminUser";
ALTER TABLE "new_AdminUser" RENAME TO "AdminUser";
CREATE UNIQUE INDEX "AdminUser_username_key" ON "AdminUser"("username");
CREATE UNIQUE INDEX "AdminUser_email_key" ON "AdminUser"("email");
CREATE INDEX "AdminUser_username_idx" ON "AdminUser"("username");
CREATE INDEX "AdminUser_role_idx" ON "AdminUser"("role");
CREATE INDEX "AdminUser_unit_idx" ON "AdminUser"("unit");
CREATE INDEX "AdminUser_studentNo_idx" ON "AdminUser"("studentNo");
CREATE INDEX "AdminUser_passportNo_idx" ON "AdminUser"("passportNo");
CREATE TABLE "new_DailyActivityReport" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "userId" TEXT NOT NULL,
    "userName" TEXT NOT NULL DEFAULT '',
    "role" TEXT,
    "unit" TEXT,
    "reportDate" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "title" TEXT,
    "description" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'submitted',
    "isLocked" BOOLEAN NOT NULL DEFAULT false,
    "updatedBy" TEXT,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME
);
INSERT INTO "new_DailyActivityReport" ("createdAt", "description", "id", "role", "title", "unit", "updatedAt", "userId", "userName") SELECT "createdAt", "description", "id", "role", "title", "unit", "updatedAt", "userId", "userName" FROM "DailyActivityReport";
DROP TABLE "DailyActivityReport";
ALTER TABLE "new_DailyActivityReport" RENAME TO "DailyActivityReport";
CREATE INDEX "DailyActivityReport_userId_idx" ON "DailyActivityReport"("userId");
CREATE INDEX "DailyActivityReport_unit_idx" ON "DailyActivityReport"("unit");
CREATE INDEX "DailyActivityReport_reportDate_idx" ON "DailyActivityReport"("reportDate");
CREATE TABLE "new_DatasetSetting" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "apiUrl" TEXT,
    "mockMode" BOOLEAN NOT NULL DEFAULT false,
    "useDatabase" BOOLEAN NOT NULL DEFAULT true,
    "provider" TEXT DEFAULT 'sqlite',
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "updatedBy" TEXT,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME
);
INSERT INTO "new_DatasetSetting" ("createdAt", "id", "updatedAt", "updatedBy") SELECT "createdAt", "id", "updatedAt", "updatedBy" FROM "DatasetSetting";
DROP TABLE "DatasetSetting";
ALTER TABLE "new_DatasetSetting" RENAME TO "DatasetSetting";
CREATE TABLE "new_FloatingMessage" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "textFa" TEXT NOT NULL DEFAULT '',
    "textEn" TEXT NOT NULL DEFAULT '',
    "textAr" TEXT NOT NULL DEFAULT '',
    "textTr" TEXT NOT NULL DEFAULT '',
    "textRu" TEXT NOT NULL DEFAULT '',
    "roles" TEXT NOT NULL DEFAULT '[]',
    "units" TEXT NOT NULL DEFAULT '[]',
    "userIds" TEXT NOT NULL DEFAULT '[]',
    "targetRole" TEXT,
    "targetUnit" TEXT,
    "targetUserId" TEXT,
    "startAt" DATETIME,
    "endAt" DATETIME,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdBy" TEXT,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME
);
INSERT INTO "new_FloatingMessage" ("createdAt", "endAt", "id", "isActive", "roles", "startAt", "textAr", "textEn", "textFa", "units", "userIds") SELECT "createdAt", "endAt", "id", "isActive", "roles", "startAt", "textAr", "textEn", "textFa", "units", "userIds" FROM "FloatingMessage";
DROP TABLE "FloatingMessage";
ALTER TABLE "new_FloatingMessage" RENAME TO "FloatingMessage";
CREATE INDEX "FloatingMessage_targetRole_idx" ON "FloatingMessage"("targetRole");
CREATE INDEX "FloatingMessage_targetUnit_idx" ON "FloatingMessage"("targetUnit");
CREATE INDEX "FloatingMessage_targetUserId_idx" ON "FloatingMessage"("targetUserId");
CREATE TABLE "new_ServiceRequest" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "requestNumber" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'pending',
    "priority" TEXT NOT NULL DEFAULT 'normal',
    "details" TEXT,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME,
    CONSTRAINT "ServiceRequest_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_ServiceRequest" ("createdAt", "details", "id", "priority", "requestNumber", "status", "type", "updatedAt", "userId") SELECT "createdAt", "details", "id", "priority", "requestNumber", "status", "type", "updatedAt", "userId" FROM "ServiceRequest";
DROP TABLE "ServiceRequest";
ALTER TABLE "new_ServiceRequest" RENAME TO "ServiceRequest";
CREATE UNIQUE INDEX "ServiceRequest_requestNumber_key" ON "ServiceRequest"("requestNumber");
CREATE TABLE "new_UploadedFile" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "fileName" TEXT NOT NULL,
    "filePath" TEXT NOT NULL,
    "fileSize" INTEGER NOT NULL,
    "mimeType" TEXT NOT NULL,
    "documentType" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "requestId" TEXT,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME,
    CONSTRAINT "UploadedFile_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_UploadedFile" ("createdAt", "documentType", "fileName", "filePath", "fileSize", "id", "mimeType", "requestId", "updatedAt", "userId") SELECT "createdAt", "documentType", "fileName", "filePath", "fileSize", "id", "mimeType", "requestId", "updatedAt", "userId" FROM "UploadedFile";
DROP TABLE "UploadedFile";
ALTER TABLE "new_UploadedFile" RENAME TO "UploadedFile";
CREATE TABLE "new_User" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "fullName" TEXT NOT NULL,
    "passportNumber" TEXT,
    "countryOfOrigin" TEXT,
    "phoneNumber" TEXT,
    "role" TEXT NOT NULL DEFAULT 'student',
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME
);
INSERT INTO "new_User" ("countryOfOrigin", "createdAt", "email", "fullName", "id", "isActive", "passportNumber", "password", "phoneNumber", "role", "updatedAt") SELECT "countryOfOrigin", "createdAt", "email", "fullName", "id", "isActive", "passportNumber", "password", "phoneNumber", "role", "updatedAt" FROM "User";
DROP TABLE "User";
ALTER TABLE "new_User" RENAME TO "User";
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");
PRAGMA foreign_keys=ON;
PRAGMA defer_foreign_keys=OFF;

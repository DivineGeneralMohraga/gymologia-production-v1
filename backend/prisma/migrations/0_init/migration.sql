-- CreateSchema
CREATE SCHEMA IF NOT EXISTS "public";

-- CreateEnum
CREATE TYPE "UserStatus" AS ENUM ('ACTIVE', 'SUSPENDED', 'DELETED');

-- CreateEnum
CREATE TYPE "OtpPurpose" AS ENUM ('LOGIN', 'ADD_MEMBER', 'ADD_STAFF', 'PHONE_CHANGE', 'PAYOUT_UPI_VERIFY');

-- CreateEnum
CREATE TYPE "AppClient" AS ENUM ('MEMBER', 'STAFF', 'REFERRAL', 'ADMIN');

-- CreateEnum
CREATE TYPE "Platform" AS ENUM ('ANDROID', 'IOS', 'WEB');

-- CreateEnum
CREATE TYPE "GymStatus" AS ENUM ('DRAFT', 'PENDING_KYC', 'ACTIVE', 'SUSPENDED', 'DELETED');

-- CreateEnum
CREATE TYPE "AltProofType" AS ENUM ('UDYAM', 'ELECTRICITY_BILL');

-- CreateEnum
CREATE TYPE "VerificationStatus" AS ENUM ('NOT_SUBMITTED', 'PENDING', 'VERIFIED', 'REJECTED');

-- CreateEnum
CREATE TYPE "Plan" AS ENUM ('BASIC', 'PRO');

-- CreateEnum
CREATE TYPE "SubscriptionStatus" AS ENUM ('PENDING', 'ACTIVE', 'EXPIRED', 'CANCELLED', 'FAILED');

-- CreateEnum
CREATE TYPE "PaymentStatus" AS ENUM ('CREATED', 'PENDING', 'SUCCESS', 'FAILED', 'REFUNDED');

-- CreateEnum
CREATE TYPE "Permission" AS ENUM ('MARK_ATTENDANCE_MEMBER', 'MARK_ATTENDANCE_STAFF', 'EDIT_ATTENDANCE_MEMBER', 'EDIT_ATTENDANCE_STAFF', 'VIEW_ATTENDANCE_MEMBER', 'VIEW_ATTENDANCE_STAFF', 'VIEW_LEAVE_MEMBER', 'VIEW_LEAVE_STAFF', 'APPROVE_LEAVE_MEMBER', 'APPROVE_LEAVE_STAFF', 'EDIT_LEAVE_DECISION', 'ADD_MEMBER', 'MANAGE_MEMBER', 'REMOVE_MEMBER', 'ADD_STAFF', 'MANAGE_STAFF', 'REMOVE_STAFF', 'ADD_ROLES', 'EDIT_PERMISSIONS', 'DELETE_ROLES', 'EDIT_ROLE_HIERARCHY', 'ADD_TRAINER', 'MANAGE_TRAINERS', 'HOST_EVENTS', 'MANAGE_EVENTS', 'VIEW_PROGRESS', 'VIEW_ANALYTICS', 'VIEW_RANKING', 'EDIT_GYM_PROFILE', 'MANAGE_SUBSCRIPTION', 'DELETE_GYM', 'SEND_NOTIFICATIONS', 'MANAGE_CHAT_GROUPS', 'ADMINISTRATIVE');

-- CreateEnum
CREATE TYPE "StaffStatus" AS ENUM ('ACTIVE', 'SUSPENDED', 'REMOVED');

-- CreateEnum
CREATE TYPE "MembershipStatus" AS ENUM ('ACTIVE', 'ON_LEAVE', 'EXPIRED', 'REMOVED');

-- CreateEnum
CREATE TYPE "ExtensionReason" AS ENUM ('PAID_RENEWAL', 'LEAVE_COMPENSATION', 'GOODWILL', 'CORRECTION');

-- CreateEnum
CREATE TYPE "MetricSource" AS ENUM ('SELF', 'STAFF');

-- CreateEnum
CREATE TYPE "SubjectType" AS ENUM ('MEMBER', 'STAFF');

-- CreateEnum
CREATE TYPE "AttendanceStatus" AS ENUM ('PRESENT', 'ABSENT', 'ON_LEAVE');

-- CreateEnum
CREATE TYPE "LeaveStatus" AS ENUM ('PENDING', 'AUTO_APPROVED', 'APPROVED', 'DECLINED', 'CANCELLED', 'CLOSED_EARLY');

-- CreateEnum
CREATE TYPE "EventStatus" AS ENUM ('DRAFT', 'PUBLISHED', 'CANCELLED', 'COMPLETED');

-- CreateEnum
CREATE TYPE "ParticipationStatus" AS ENUM ('REGISTERED', 'WITHDRAWN');

-- CreateEnum
CREATE TYPE "ConversationType" AS ENUM ('DIRECT', 'OFFICIAL_GROUP', 'UNOFFICIAL_GROUP', 'CUSTOM_GROUP');

-- CreateEnum
CREATE TYPE "ContentType" AS ENUM ('TEXT', 'IMAGE', 'FILE', 'SYSTEM');

-- CreateEnum
CREATE TYPE "Discipline" AS ENUM ('STRENGTH', 'CARDIO', 'YOGA', 'MOBILITY', 'CALISTHENICS');

-- CreateEnum
CREATE TYPE "MuscleGroup" AS ENUM ('CHEST', 'BACK', 'SHOULDERS', 'BICEPS', 'TRICEPS', 'FOREARMS', 'CORE', 'GLUTES', 'QUADS', 'HAMSTRINGS', 'CALVES', 'FULL_BODY');

-- CreateEnum
CREATE TYPE "TrainingGoal" AS ENUM ('MUSCLE_GAIN', 'FAT_LOSS', 'STRENGTH', 'ENDURANCE', 'FLEXIBILITY', 'REHAB', 'GENERAL_FITNESS');

-- CreateEnum
CREATE TYPE "Difficulty" AS ENUM ('BEGINNER', 'INTERMEDIATE', 'ADVANCED');

-- CreateEnum
CREATE TYPE "NotificationSource" AS ENUM ('GYM', 'GYMOLOGIA');

-- CreateEnum
CREATE TYPE "NotificationAudience" AS ENUM ('GYM_MEMBERS', 'GYM_STAFF', 'GYM_EVERYONE', 'ALL_MEMBERS', 'ALL_OWNERS', 'ALL_STAFF', 'ALL_REFERRERS', 'EVERYONE');

-- CreateEnum
CREATE TYPE "ReferralAccountStatus" AS ENUM ('ACTIVE', 'SUSPENDED', 'BLOCKED');

-- CreateEnum
CREATE TYPE "RedemptionStatus" AS ENUM ('PENDING', 'ELIGIBLE', 'PAID', 'REVERSED');

-- CreateEnum
CREATE TYPE "PayoutStatus" AS ENUM ('QUEUED', 'PROCESSING', 'SUCCESS', 'FAILED', 'REVERSED');

-- CreateEnum
CREATE TYPE "AdminRole" AS ENUM ('OWNER', 'ADMIN', 'MANAGER', 'CUSTOMER_SUPPORT', 'KYC_AGENT');

-- CreateEnum
CREATE TYPE "KycSessionStatus" AS ENUM ('SCHEDULED', 'IN_PROGRESS', 'COMPLETED', 'NO_SHOW', 'CANCELLED');

-- CreateEnum
CREATE TYPE "TicketStatus" AS ENUM ('OPEN', 'IN_PROGRESS', 'WAITING_ON_USER', 'RESOLVED', 'CLOSED');

-- CreateEnum
CREATE TYPE "TicketPriority" AS ENUM ('LOW', 'NORMAL', 'HIGH', 'URGENT');

-- CreateEnum
CREATE TYPE "SecurityEventType" AS ENUM ('OTP_ABUSE', 'BRUTE_FORCE', 'INVALID_TOKEN', 'PERMISSION_DENIED', 'INJECTION_ATTEMPT', 'RATE_LIMIT_TRIPPED', 'WEBHOOK_SIGNATURE_INVALID', 'PAYOUT_VELOCITY', 'REFERRAL_FRAUD', 'SUSPICIOUS_UPLOAD', 'ANOMALOUS_LOGIN');

-- CreateEnum
CREATE TYPE "Severity" AS ENUM ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL');

-- CreateTable
CREATE TABLE "users" (
    "id" UUID NOT NULL,
    "phone" VARCHAR(16) NOT NULL,
    "name" VARCHAR(120) NOT NULL,
    "email" VARCHAR(255),
    "age" INTEGER,
    "avatarUrl" VARCHAR(500),
    "locale" VARCHAR(10) NOT NULL DEFAULT 'en',
    "status" "UserStatus" NOT NULL DEFAULT 'ACTIVE',
    "phoneVerified" BOOLEAN NOT NULL DEFAULT false,
    "lastLoginAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "otp_challenges" (
    "id" UUID NOT NULL,
    "phone" VARCHAR(16) NOT NULL,
    "codeHash" VARCHAR(255) NOT NULL,
    "salt" VARCHAR(64) NOT NULL,
    "purpose" "OtpPurpose" NOT NULL,
    "attempts" INTEGER NOT NULL DEFAULT 0,
    "maxTries" INTEGER NOT NULL DEFAULT 5,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "consumedAt" TIMESTAMP(3),
    "requestIp" VARCHAR(64),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "otp_challenges_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "sessions" (
    "id" UUID NOT NULL,
    "userId" UUID NOT NULL,
    "tokenHash" VARCHAR(255) NOT NULL,
    "appClient" "AppClient" NOT NULL,
    "deviceId" VARCHAR(128),
    "ip" VARCHAR(64),
    "userAgent" VARCHAR(300),
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "revokedAt" TIMESTAMP(3),
    "lastUsedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "sessions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "devices" (
    "id" UUID NOT NULL,
    "userId" UUID NOT NULL,
    "fcmToken" VARCHAR(500) NOT NULL,
    "platform" "Platform" NOT NULL,
    "appClient" "AppClient" NOT NULL,
    "lastSeenAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "devices_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "gyms" (
    "id" UUID NOT NULL,
    "ownerId" UUID NOT NULL,
    "name" VARCHAR(150) NOT NULL,
    "description" TEXT,
    "addressLine1" VARCHAR(200) NOT NULL,
    "addressLine2" VARCHAR(200),
    "state" VARCHAR(80) NOT NULL,
    "district" VARCHAR(80) NOT NULL,
    "city" VARCHAR(80) NOT NULL,
    "pincode" VARCHAR(10) NOT NULL,
    "latitude" DECIMAL(10,7),
    "longitude" DECIMAL(10,7),
    "contactPhone" VARCHAR(16) NOT NULL,
    "maxLeaveDaysPerMonth" INTEGER NOT NULL DEFAULT 4,
    "maxLeaveDaysPerMembership" INTEGER NOT NULL DEFAULT 30,
    "status" "GymStatus" NOT NULL DEFAULT 'DRAFT',
    "publicListing" BOOLEAN NOT NULL DEFAULT true,
    "ratingAverage" DECIMAL(3,2) NOT NULL DEFAULT 0,
    "ratingCount" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "gyms_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "gym_images" (
    "id" UUID NOT NULL,
    "gymId" UUID NOT NULL,
    "url" VARCHAR(500) NOT NULL,
    "sortOrder" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "gym_images_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "gym_perks" (
    "id" UUID NOT NULL,
    "gymId" UUID NOT NULL,
    "label" VARCHAR(120) NOT NULL,

    CONSTRAINT "gym_perks_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "gym_ratings" (
    "id" UUID NOT NULL,
    "gymId" UUID NOT NULL,
    "userId" UUID NOT NULL,
    "stars" SMALLINT NOT NULL,
    "comment" VARCHAR(500),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "gym_ratings_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "gym_kyc" (
    "id" UUID NOT NULL,
    "gymId" UUID NOT NULL,
    "aadhaarEnc" TEXT,
    "aadhaarLast4" VARCHAR(4),
    "panEnc" TEXT,
    "panLast4" VARCHAR(4),
    "gstinEnc" TEXT,
    "gstinLast4" VARCHAR(4),
    "altProofUrl" VARCHAR(500),
    "altProofType" "AltProofType",
    "aadhaarStatus" "VerificationStatus" NOT NULL DEFAULT 'NOT_SUBMITTED',
    "panStatus" "VerificationStatus" NOT NULL DEFAULT 'NOT_SUBMITTED',
    "gstStatus" "VerificationStatus" NOT NULL DEFAULT 'NOT_SUBMITTED',
    "videoKycStatus" "VerificationStatus" NOT NULL DEFAULT 'NOT_SUBMITTED',
    "cashfreeAadhaarRefId" VARCHAR(120),
    "cashfreePanRefId" VARCHAR(120),
    "cashfreeGstRefId" VARCHAR(120),
    "rejectionReason" VARCHAR(500),
    "verifiedAt" TIMESTAMP(3),
    "verifiedByAdminId" UUID,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "gym_kyc_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "gym_subscriptions" (
    "id" UUID NOT NULL,
    "gymId" UUID NOT NULL,
    "plan" "Plan" NOT NULL,
    "status" "SubscriptionStatus" NOT NULL DEFAULT 'PENDING',
    "startsAt" TIMESTAMP(3) NOT NULL,
    "endsAt" TIMESTAMP(3) NOT NULL,
    "isTrial" BOOLEAN NOT NULL DEFAULT false,
    "basePricePaise" INTEGER NOT NULL,
    "discountPaise" INTEGER NOT NULL DEFAULT 0,
    "taxPaise" INTEGER NOT NULL DEFAULT 0,
    "amountPayablePaise" INTEGER NOT NULL,
    "referralCodeUsed" VARCHAR(20),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "gym_subscriptions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "payments" (
    "id" UUID NOT NULL,
    "subscriptionId" UUID NOT NULL,
    "cashfreeOrderId" VARCHAR(120) NOT NULL,
    "cashfreePaymentId" VARCHAR(120),
    "amountPaise" INTEGER NOT NULL,
    "currency" VARCHAR(3) NOT NULL DEFAULT 'INR',
    "status" "PaymentStatus" NOT NULL DEFAULT 'CREATED',
    "method" VARCHAR(60),
    "webhookPayload" JSONB,
    "failureReason" VARCHAR(500),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "paidAt" TIMESTAMP(3),

    CONSTRAINT "payments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "roles" (
    "id" UUID NOT NULL,
    "gymId" UUID NOT NULL,
    "name" VARCHAR(60) NOT NULL,
    "level" INTEGER NOT NULL,
    "isSystem" BOOLEAN NOT NULL DEFAULT false,
    "isSuper" BOOLEAN NOT NULL DEFAULT false,
    "exemptFromAttendance" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "roles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "role_permissions" (
    "id" UUID NOT NULL,
    "roleId" UUID NOT NULL,
    "permission" "Permission" NOT NULL,

    CONSTRAINT "role_permissions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "staff_members" (
    "id" UUID NOT NULL,
    "gymId" UUID NOT NULL,
    "userId" UUID NOT NULL,
    "roleId" UUID NOT NULL,
    "isTrainer" BOOLEAN NOT NULL DEFAULT false,
    "trainerCategoryId" UUID,
    "addressProofApproved" BOOLEAN NOT NULL DEFAULT false,
    "addressProofUrl" VARCHAR(500),
    "status" "StaffStatus" NOT NULL DEFAULT 'ACTIVE',
    "joinedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "removedAt" TIMESTAMP(3),
    "addedById" UUID,

    CONSTRAINT "staff_members_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "trainer_categories" (
    "id" UUID NOT NULL,
    "gymId" UUID NOT NULL,
    "name" VARCHAR(60) NOT NULL,
    "allowsMultipleMembers" BOOLEAN NOT NULL DEFAULT true,
    "sortOrder" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "trainer_categories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "memberships" (
    "id" UUID NOT NULL,
    "gymId" UUID NOT NULL,
    "userId" UUID NOT NULL,
    "startsAt" TIMESTAMP(3) NOT NULL,
    "endsAt" TIMESTAMP(3) NOT NULL,
    "planMonths" INTEGER NOT NULL,
    "maxLeaveDays" INTEGER NOT NULL,
    "leaveDaysUsed" INTEGER NOT NULL DEFAULT 0,
    "assignedTrainerId" UUID,
    "goal" VARCHAR(300),
    "allowProgressMonitoring" BOOLEAN NOT NULL DEFAULT true,
    "addressProofApproved" BOOLEAN NOT NULL DEFAULT false,
    "status" "MembershipStatus" NOT NULL DEFAULT 'ACTIVE',
    "addedById" UUID,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "memberships_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "membership_extensions" (
    "id" UUID NOT NULL,
    "membershipId" UUID NOT NULL,
    "previousEndsAt" TIMESTAMP(3) NOT NULL,
    "newEndsAt" TIMESTAMP(3) NOT NULL,
    "reason" "ExtensionReason" NOT NULL,
    "note" VARCHAR(300),
    "actorId" UUID,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "membership_extensions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "body_metrics" (
    "id" UUID NOT NULL,
    "userId" UUID NOT NULL,
    "weightKg" DECIMAL(5,2),
    "heightCm" DECIMAL(5,2),
    "recordedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "source" "MetricSource" NOT NULL DEFAULT 'SELF',

    CONSTRAINT "body_metrics_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "attendance_records" (
    "id" UUID NOT NULL,
    "gymId" UUID NOT NULL,
    "subjectType" "SubjectType" NOT NULL,
    "subjectId" UUID NOT NULL,
    "date" DATE NOT NULL,
    "status" "AttendanceStatus" NOT NULL,
    "markedById" UUID NOT NULL,
    "markedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "editedById" UUID,
    "editedAt" TIMESTAMP(3),
    "editReason" VARCHAR(300),

    CONSTRAINT "attendance_records_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "leave_requests" (
    "id" UUID NOT NULL,
    "gymId" UUID NOT NULL,
    "subjectType" "SubjectType" NOT NULL,
    "subjectId" UUID NOT NULL,
    "fromDate" DATE NOT NULL,
    "toDate" DATE NOT NULL,
    "days" INTEGER NOT NULL,
    "reason" VARCHAR(500),
    "status" "LeaveStatus" NOT NULL DEFAULT 'PENDING',
    "requiresElevatedApproval" BOOLEAN NOT NULL DEFAULT false,
    "decidedById" UUID,
    "decidedAt" TIMESTAMP(3),
    "decisionNote" VARCHAR(300),
    "closedEarlyAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "leave_requests_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "leave_decision_overrides" (
    "id" UUID NOT NULL,
    "leaveRequestId" UUID NOT NULL,
    "previousStatus" "LeaveStatus" NOT NULL,
    "newStatus" "LeaveStatus" NOT NULL,
    "originalDeciderId" UUID NOT NULL,
    "actorId" UUID NOT NULL,
    "reason" VARCHAR(300),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "leave_decision_overrides_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "events" (
    "id" UUID NOT NULL,
    "gymId" UUID NOT NULL,
    "title" VARCHAR(150) NOT NULL,
    "bannerUrl" VARCHAR(500),
    "description" TEXT NOT NULL,
    "howToParticipate" TEXT NOT NULL,
    "prize" VARCHAR(200),
    "prizeDescription" TEXT,
    "registrationLastDate" TIMESTAMP(3) NOT NULL,
    "startsAt" TIMESTAMP(3) NOT NULL,
    "endsAt" TIMESTAMP(3) NOT NULL,
    "membersCanParticipate" BOOLEAN NOT NULL DEFAULT true,
    "publicListing" BOOLEAN NOT NULL DEFAULT true,
    "allowNonMembers" BOOLEAN NOT NULL DEFAULT false,
    "status" "EventStatus" NOT NULL DEFAULT 'PUBLISHED',
    "createdById" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "events_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "event_participations" (
    "id" UUID NOT NULL,
    "eventId" UUID NOT NULL,
    "userId" UUID NOT NULL,
    "status" "ParticipationStatus" NOT NULL DEFAULT 'REGISTERED',
    "registeredAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "withdrawnAt" TIMESTAMP(3),

    CONSTRAINT "event_participations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "conversations" (
    "id" UUID NOT NULL,
    "gymId" UUID,
    "type" "ConversationType" NOT NULL,
    "name" VARCHAR(120),
    "createdById" UUID,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "lastMessageAt" TIMESTAMP(3),

    CONSTRAINT "conversations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "conversation_members" (
    "id" UUID NOT NULL,
    "conversationId" UUID NOT NULL,
    "userId" UUID NOT NULL,
    "isAdmin" BOOLEAN NOT NULL DEFAULT false,
    "joinedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "leftAt" TIMESTAMP(3),
    "lastReadAt" TIMESTAMP(3),
    "muted" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "conversation_members_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "messages" (
    "id" UUID NOT NULL,
    "conversationId" UUID NOT NULL,
    "senderId" UUID NOT NULL,
    "ciphertext" TEXT NOT NULL,
    "nonce" VARCHAR(64) NOT NULL,
    "contentType" "ContentType" NOT NULL DEFAULT 'TEXT',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deletedAt" TIMESTAMP(3),

    CONSTRAINT "messages_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "device_keys" (
    "id" UUID NOT NULL,
    "userId" UUID NOT NULL,
    "deviceId" VARCHAR(128) NOT NULL,
    "publicKey" TEXT NOT NULL,
    "signedPreKey" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "revokedAt" TIMESTAMP(3),

    CONSTRAINT "device_keys_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "exercises" (
    "id" UUID NOT NULL,
    "slug" VARCHAR(120) NOT NULL,
    "discipline" "Discipline" NOT NULL,
    "primaryMuscle" "MuscleGroup" NOT NULL,
    "goals" "TrainingGoal"[],
    "difficulty" "Difficulty" NOT NULL DEFAULT 'BEGINNER',
    "equipment" VARCHAR(120),
    "imageUrl" VARCHAR(500),
    "videoUrl" VARCHAR(500),
    "isPublished" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "exercises_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "exercise_translations" (
    "id" UUID NOT NULL,
    "exerciseId" UUID NOT NULL,
    "locale" VARCHAR(10) NOT NULL,
    "name" VARCHAR(150) NOT NULL,
    "summary" VARCHAR(500),
    "steps" TEXT[],
    "cautions" TEXT[],

    CONSTRAINT "exercise_translations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "notifications" (
    "id" UUID NOT NULL,
    "gymId" UUID,
    "source" "NotificationSource" NOT NULL,
    "audience" "NotificationAudience" NOT NULL,
    "title" VARCHAR(150) NOT NULL,
    "body" TEXT NOT NULL,
    "deepLink" VARCHAR(300),
    "senderId" UUID,
    "sentAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "notifications_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "notification_recipients" (
    "id" UUID NOT NULL,
    "notificationId" UUID NOT NULL,
    "userId" UUID NOT NULL,
    "readAt" TIMESTAMP(3),
    "deliveredAt" TIMESTAMP(3),

    CONSTRAINT "notification_recipients_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "referral_accounts" (
    "id" UUID NOT NULL,
    "userId" UUID NOT NULL,
    "code" VARCHAR(20) NOT NULL,
    "status" "ReferralAccountStatus" NOT NULL DEFAULT 'ACTIVE',
    "upiIdEnc" TEXT,
    "upiIdMasked" VARCHAR(60),
    "upiHolderName" VARCHAR(120),
    "upiVerified" BOOLEAN NOT NULL DEFAULT false,
    "upiVerifiedAt" TIMESTAMP(3),
    "panEnc" TEXT,
    "panLast4" VARCHAR(4),
    "panStatus" "VerificationStatus" NOT NULL DEFAULT 'NOT_SUBMITTED',
    "totalEarnedPaise" INTEGER NOT NULL DEFAULT 0,
    "totalPaidPaise" INTEGER NOT NULL DEFAULT 0,
    "totalTdsPaise" INTEGER NOT NULL DEFAULT 0,
    "pendingPaise" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "referral_accounts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "referral_redemptions" (
    "id" UUID NOT NULL,
    "referralAccountId" UUID NOT NULL,
    "subscriptionId" UUID NOT NULL,
    "gymId" UUID NOT NULL,
    "discountPaise" INTEGER NOT NULL,
    "rewardPaise" INTEGER NOT NULL,
    "status" "RedemptionStatus" NOT NULL DEFAULT 'PENDING',
    "eligibleAt" TIMESTAMP(3),
    "payoutId" UUID,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "referral_redemptions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "payouts" (
    "id" UUID NOT NULL,
    "referralAccountId" UUID NOT NULL,
    "grossPaise" INTEGER NOT NULL,
    "tdsPaise" INTEGER NOT NULL DEFAULT 0,
    "tdsRateBps" INTEGER NOT NULL DEFAULT 0,
    "verifyFeePaise" INTEGER NOT NULL DEFAULT 0,
    "netPaise" INTEGER NOT NULL,
    "status" "PayoutStatus" NOT NULL DEFAULT 'QUEUED',
    "cashfreeTransferId" VARCHAR(120),
    "cashfreeUtr" VARCHAR(120),
    "failureReason" VARCHAR(500),
    "idempotencyKey" VARCHAR(80) NOT NULL,
    "financialYear" VARCHAR(9) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "processedAt" TIMESTAMP(3),

    CONSTRAINT "payouts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "admin_staff" (
    "id" UUID NOT NULL,
    "userId" UUID NOT NULL,
    "role" "AdminRole" NOT NULL,
    "status" "StaffStatus" NOT NULL DEFAULT 'ACTIVE',
    "dateOfBirth" DATE,
    "workEmail" VARCHAR(255),
    "addedById" UUID,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "admin_staff_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "kyc_sessions" (
    "id" UUID NOT NULL,
    "gymKycId" UUID NOT NULL,
    "adminStaffId" UUID,
    "scheduledAt" TIMESTAMP(3) NOT NULL,
    "joinTokenHash" VARCHAR(255) NOT NULL,
    "tokenExpiresAt" TIMESTAMP(3) NOT NULL,
    "startedAt" TIMESTAMP(3),
    "endedAt" TIMESTAMP(3),
    "status" "KycSessionStatus" NOT NULL DEFAULT 'SCHEDULED',
    "outcome" "VerificationStatus",
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "kyc_sessions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "support_tickets" (
    "id" UUID NOT NULL,
    "userId" UUID,
    "appClient" "AppClient" NOT NULL,
    "contactPhone" VARCHAR(16) NOT NULL,
    "contactEmail" VARCHAR(255),
    "subject" VARCHAR(200) NOT NULL,
    "message" TEXT NOT NULL,
    "status" "TicketStatus" NOT NULL DEFAULT 'OPEN',
    "priority" "TicketPriority" NOT NULL DEFAULT 'NORMAL',
    "assignedAdminId" UUID,
    "resolutionNote" TEXT,
    "resolvedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "support_tickets_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "audit_logs" (
    "id" UUID NOT NULL,
    "actorId" UUID,
    "gymId" UUID,
    "action" VARCHAR(80) NOT NULL,
    "entityType" VARCHAR(60) NOT NULL,
    "entityId" VARCHAR(64),
    "before" JSONB,
    "after" JSONB,
    "ip" VARCHAR(64),
    "userAgent" VARCHAR(300),
    "appClient" "AppClient",
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "audit_logs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "security_events" (
    "id" UUID NOT NULL,
    "type" "SecurityEventType" NOT NULL,
    "severity" "Severity" NOT NULL DEFAULT 'LOW',
    "userId" UUID,
    "ip" VARCHAR(64),
    "userAgent" VARCHAR(300),
    "route" VARCHAR(200),
    "details" JSONB,
    "actionTaken" VARCHAR(200),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "security_events_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "app_install_stats" (
    "id" UUID NOT NULL,
    "appClient" "AppClient" NOT NULL,
    "platform" "Platform" NOT NULL,
    "day" DATE NOT NULL,
    "installs" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "app_install_stats_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_phone_key" ON "users"("phone");

-- CreateIndex
CREATE INDEX "users_status_idx" ON "users"("status");

-- CreateIndex
CREATE INDEX "otp_challenges_phone_purpose_expiresAt_idx" ON "otp_challenges"("phone", "purpose", "expiresAt");

-- CreateIndex
CREATE UNIQUE INDEX "sessions_tokenHash_key" ON "sessions"("tokenHash");

-- CreateIndex
CREATE INDEX "sessions_userId_revokedAt_idx" ON "sessions"("userId", "revokedAt");

-- CreateIndex
CREATE UNIQUE INDEX "devices_fcmToken_key" ON "devices"("fcmToken");

-- CreateIndex
CREATE INDEX "devices_userId_idx" ON "devices"("userId");

-- CreateIndex
CREATE INDEX "gyms_state_district_status_idx" ON "gyms"("state", "district", "status");

-- CreateIndex
CREATE INDEX "gyms_status_publicListing_idx" ON "gyms"("status", "publicListing");

-- CreateIndex
CREATE INDEX "gym_images_gymId_idx" ON "gym_images"("gymId");

-- CreateIndex
CREATE INDEX "gym_perks_gymId_idx" ON "gym_perks"("gymId");

-- CreateIndex
CREATE INDEX "gym_ratings_gymId_idx" ON "gym_ratings"("gymId");

-- CreateIndex
CREATE UNIQUE INDEX "gym_ratings_gymId_userId_key" ON "gym_ratings"("gymId", "userId");

-- CreateIndex
CREATE UNIQUE INDEX "gym_kyc_gymId_key" ON "gym_kyc"("gymId");

-- CreateIndex
CREATE INDEX "gym_subscriptions_gymId_status_idx" ON "gym_subscriptions"("gymId", "status");

-- CreateIndex
CREATE INDEX "gym_subscriptions_endsAt_status_idx" ON "gym_subscriptions"("endsAt", "status");

-- CreateIndex
CREATE UNIQUE INDEX "payments_subscriptionId_key" ON "payments"("subscriptionId");

-- CreateIndex
CREATE UNIQUE INDEX "payments_cashfreeOrderId_key" ON "payments"("cashfreeOrderId");

-- CreateIndex
CREATE INDEX "payments_status_idx" ON "payments"("status");

-- CreateIndex
CREATE INDEX "roles_gymId_level_idx" ON "roles"("gymId", "level");

-- CreateIndex
CREATE UNIQUE INDEX "roles_gymId_name_key" ON "roles"("gymId", "name");

-- CreateIndex
CREATE INDEX "role_permissions_roleId_idx" ON "role_permissions"("roleId");

-- CreateIndex
CREATE UNIQUE INDEX "role_permissions_roleId_permission_key" ON "role_permissions"("roleId", "permission");

-- CreateIndex
CREATE INDEX "staff_members_gymId_status_idx" ON "staff_members"("gymId", "status");

-- CreateIndex
CREATE UNIQUE INDEX "staff_members_gymId_userId_key" ON "staff_members"("gymId", "userId");

-- CreateIndex
CREATE UNIQUE INDEX "trainer_categories_gymId_name_key" ON "trainer_categories"("gymId", "name");

-- CreateIndex
CREATE INDEX "memberships_gymId_status_idx" ON "memberships"("gymId", "status");

-- CreateIndex
CREATE INDEX "memberships_userId_status_idx" ON "memberships"("userId", "status");

-- CreateIndex
CREATE INDEX "memberships_endsAt_status_idx" ON "memberships"("endsAt", "status");

-- CreateIndex
CREATE INDEX "membership_extensions_membershipId_idx" ON "membership_extensions"("membershipId");

-- CreateIndex
CREATE INDEX "body_metrics_userId_recordedAt_idx" ON "body_metrics"("userId", "recordedAt");

-- CreateIndex
CREATE INDEX "attendance_records_gymId_date_idx" ON "attendance_records"("gymId", "date");

-- CreateIndex
CREATE INDEX "attendance_records_subjectId_date_idx" ON "attendance_records"("subjectId", "date");

-- CreateIndex
CREATE UNIQUE INDEX "attendance_records_gymId_subjectId_date_key" ON "attendance_records"("gymId", "subjectId", "date");

-- CreateIndex
CREATE INDEX "leave_requests_gymId_status_idx" ON "leave_requests"("gymId", "status");

-- CreateIndex
CREATE INDEX "leave_requests_subjectId_status_idx" ON "leave_requests"("subjectId", "status");

-- CreateIndex
CREATE INDEX "leave_decision_overrides_leaveRequestId_idx" ON "leave_decision_overrides"("leaveRequestId");

-- CreateIndex
CREATE INDEX "events_gymId_status_idx" ON "events"("gymId", "status");

-- CreateIndex
CREATE INDEX "events_status_publicListing_startsAt_idx" ON "events"("status", "publicListing", "startsAt");

-- CreateIndex
CREATE INDEX "event_participations_eventId_idx" ON "event_participations"("eventId");

-- CreateIndex
CREATE UNIQUE INDEX "event_participations_eventId_userId_key" ON "event_participations"("eventId", "userId");

-- CreateIndex
CREATE INDEX "conversations_gymId_type_idx" ON "conversations"("gymId", "type");

-- CreateIndex
CREATE INDEX "conversation_members_userId_idx" ON "conversation_members"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "conversation_members_conversationId_userId_key" ON "conversation_members"("conversationId", "userId");

-- CreateIndex
CREATE INDEX "messages_conversationId_createdAt_idx" ON "messages"("conversationId", "createdAt");

-- CreateIndex
CREATE UNIQUE INDEX "device_keys_userId_deviceId_key" ON "device_keys"("userId", "deviceId");

-- CreateIndex
CREATE UNIQUE INDEX "exercises_slug_key" ON "exercises"("slug");

-- CreateIndex
CREATE INDEX "exercises_discipline_primaryMuscle_idx" ON "exercises"("discipline", "primaryMuscle");

-- CreateIndex
CREATE UNIQUE INDEX "exercise_translations_exerciseId_locale_key" ON "exercise_translations"("exerciseId", "locale");

-- CreateIndex
CREATE INDEX "notifications_gymId_sentAt_idx" ON "notifications"("gymId", "sentAt");

-- CreateIndex
CREATE INDEX "notification_recipients_userId_readAt_idx" ON "notification_recipients"("userId", "readAt");

-- CreateIndex
CREATE UNIQUE INDEX "notification_recipients_notificationId_userId_key" ON "notification_recipients"("notificationId", "userId");

-- CreateIndex
CREATE UNIQUE INDEX "referral_accounts_userId_key" ON "referral_accounts"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "referral_accounts_code_key" ON "referral_accounts"("code");

-- CreateIndex
CREATE UNIQUE INDEX "referral_redemptions_subscriptionId_key" ON "referral_redemptions"("subscriptionId");

-- CreateIndex
CREATE INDEX "referral_redemptions_referralAccountId_status_idx" ON "referral_redemptions"("referralAccountId", "status");

-- CreateIndex
CREATE UNIQUE INDEX "payouts_cashfreeTransferId_key" ON "payouts"("cashfreeTransferId");

-- CreateIndex
CREATE UNIQUE INDEX "payouts_idempotencyKey_key" ON "payouts"("idempotencyKey");

-- CreateIndex
CREATE INDEX "payouts_referralAccountId_status_idx" ON "payouts"("referralAccountId", "status");

-- CreateIndex
CREATE INDEX "payouts_financialYear_idx" ON "payouts"("financialYear");

-- CreateIndex
CREATE UNIQUE INDEX "admin_staff_userId_key" ON "admin_staff"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "kyc_sessions_joinTokenHash_key" ON "kyc_sessions"("joinTokenHash");

-- CreateIndex
CREATE INDEX "kyc_sessions_status_scheduledAt_idx" ON "kyc_sessions"("status", "scheduledAt");

-- CreateIndex
CREATE INDEX "support_tickets_status_priority_idx" ON "support_tickets"("status", "priority");

-- CreateIndex
CREATE INDEX "audit_logs_gymId_createdAt_idx" ON "audit_logs"("gymId", "createdAt");

-- CreateIndex
CREATE INDEX "audit_logs_actorId_createdAt_idx" ON "audit_logs"("actorId", "createdAt");

-- CreateIndex
CREATE INDEX "audit_logs_action_createdAt_idx" ON "audit_logs"("action", "createdAt");

-- CreateIndex
CREATE INDEX "security_events_type_createdAt_idx" ON "security_events"("type", "createdAt");

-- CreateIndex
CREATE INDEX "security_events_ip_createdAt_idx" ON "security_events"("ip", "createdAt");

-- CreateIndex
CREATE INDEX "security_events_severity_createdAt_idx" ON "security_events"("severity", "createdAt");

-- CreateIndex
CREATE UNIQUE INDEX "app_install_stats_appClient_platform_day_key" ON "app_install_stats"("appClient", "platform", "day");

-- AddForeignKey
ALTER TABLE "sessions" ADD CONSTRAINT "sessions_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "devices" ADD CONSTRAINT "devices_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "gyms" ADD CONSTRAINT "gyms_ownerId_fkey" FOREIGN KEY ("ownerId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "gym_images" ADD CONSTRAINT "gym_images_gymId_fkey" FOREIGN KEY ("gymId") REFERENCES "gyms"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "gym_perks" ADD CONSTRAINT "gym_perks_gymId_fkey" FOREIGN KEY ("gymId") REFERENCES "gyms"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "gym_ratings" ADD CONSTRAINT "gym_ratings_gymId_fkey" FOREIGN KEY ("gymId") REFERENCES "gyms"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "gym_ratings" ADD CONSTRAINT "gym_ratings_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "gym_kyc" ADD CONSTRAINT "gym_kyc_gymId_fkey" FOREIGN KEY ("gymId") REFERENCES "gyms"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "gym_subscriptions" ADD CONSTRAINT "gym_subscriptions_gymId_fkey" FOREIGN KEY ("gymId") REFERENCES "gyms"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payments" ADD CONSTRAINT "payments_subscriptionId_fkey" FOREIGN KEY ("subscriptionId") REFERENCES "gym_subscriptions"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "roles" ADD CONSTRAINT "roles_gymId_fkey" FOREIGN KEY ("gymId") REFERENCES "gyms"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "role_permissions" ADD CONSTRAINT "role_permissions_roleId_fkey" FOREIGN KEY ("roleId") REFERENCES "roles"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "staff_members" ADD CONSTRAINT "staff_members_gymId_fkey" FOREIGN KEY ("gymId") REFERENCES "gyms"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "staff_members" ADD CONSTRAINT "staff_members_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "staff_members" ADD CONSTRAINT "staff_members_roleId_fkey" FOREIGN KEY ("roleId") REFERENCES "roles"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "staff_members" ADD CONSTRAINT "staff_members_trainerCategoryId_fkey" FOREIGN KEY ("trainerCategoryId") REFERENCES "trainer_categories"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "trainer_categories" ADD CONSTRAINT "trainer_categories_gymId_fkey" FOREIGN KEY ("gymId") REFERENCES "gyms"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "memberships" ADD CONSTRAINT "memberships_gymId_fkey" FOREIGN KEY ("gymId") REFERENCES "gyms"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "memberships" ADD CONSTRAINT "memberships_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "memberships" ADD CONSTRAINT "memberships_assignedTrainerId_fkey" FOREIGN KEY ("assignedTrainerId") REFERENCES "staff_members"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "membership_extensions" ADD CONSTRAINT "membership_extensions_membershipId_fkey" FOREIGN KEY ("membershipId") REFERENCES "memberships"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "body_metrics" ADD CONSTRAINT "body_metrics_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "attendance_records" ADD CONSTRAINT "attendance_records_gymId_fkey" FOREIGN KEY ("gymId") REFERENCES "gyms"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "attendance_records" ADD CONSTRAINT "attendance_records_subjectId_fkey" FOREIGN KEY ("subjectId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "attendance_records" ADD CONSTRAINT "attendance_records_markedById_fkey" FOREIGN KEY ("markedById") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "attendance_records" ADD CONSTRAINT "attendance_records_editedById_fkey" FOREIGN KEY ("editedById") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "leave_requests" ADD CONSTRAINT "leave_requests_gymId_fkey" FOREIGN KEY ("gymId") REFERENCES "gyms"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "leave_requests" ADD CONSTRAINT "leave_requests_subjectId_fkey" FOREIGN KEY ("subjectId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "leave_requests" ADD CONSTRAINT "leave_requests_decidedById_fkey" FOREIGN KEY ("decidedById") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "leave_decision_overrides" ADD CONSTRAINT "leave_decision_overrides_leaveRequestId_fkey" FOREIGN KEY ("leaveRequestId") REFERENCES "leave_requests"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "events" ADD CONSTRAINT "events_gymId_fkey" FOREIGN KEY ("gymId") REFERENCES "gyms"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "event_participations" ADD CONSTRAINT "event_participations_eventId_fkey" FOREIGN KEY ("eventId") REFERENCES "events"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "event_participations" ADD CONSTRAINT "event_participations_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "conversations" ADD CONSTRAINT "conversations_gymId_fkey" FOREIGN KEY ("gymId") REFERENCES "gyms"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "conversation_members" ADD CONSTRAINT "conversation_members_conversationId_fkey" FOREIGN KEY ("conversationId") REFERENCES "conversations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "conversation_members" ADD CONSTRAINT "conversation_members_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "messages" ADD CONSTRAINT "messages_conversationId_fkey" FOREIGN KEY ("conversationId") REFERENCES "conversations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "messages" ADD CONSTRAINT "messages_senderId_fkey" FOREIGN KEY ("senderId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "exercise_translations" ADD CONSTRAINT "exercise_translations_exerciseId_fkey" FOREIGN KEY ("exerciseId") REFERENCES "exercises"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "notifications" ADD CONSTRAINT "notifications_gymId_fkey" FOREIGN KEY ("gymId") REFERENCES "gyms"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "notification_recipients" ADD CONSTRAINT "notification_recipients_notificationId_fkey" FOREIGN KEY ("notificationId") REFERENCES "notifications"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "notification_recipients" ADD CONSTRAINT "notification_recipients_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "referral_accounts" ADD CONSTRAINT "referral_accounts_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "referral_redemptions" ADD CONSTRAINT "referral_redemptions_referralAccountId_fkey" FOREIGN KEY ("referralAccountId") REFERENCES "referral_accounts"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "referral_redemptions" ADD CONSTRAINT "referral_redemptions_subscriptionId_fkey" FOREIGN KEY ("subscriptionId") REFERENCES "gym_subscriptions"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "referral_redemptions" ADD CONSTRAINT "referral_redemptions_payoutId_fkey" FOREIGN KEY ("payoutId") REFERENCES "payouts"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payouts" ADD CONSTRAINT "payouts_referralAccountId_fkey" FOREIGN KEY ("referralAccountId") REFERENCES "referral_accounts"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "admin_staff" ADD CONSTRAINT "admin_staff_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "kyc_sessions" ADD CONSTRAINT "kyc_sessions_gymKycId_fkey" FOREIGN KEY ("gymKycId") REFERENCES "gym_kyc"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "kyc_sessions" ADD CONSTRAINT "kyc_sessions_adminStaffId_fkey" FOREIGN KEY ("adminStaffId") REFERENCES "admin_staff"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "support_tickets" ADD CONSTRAINT "support_tickets_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "support_tickets" ADD CONSTRAINT "support_tickets_assignedAdminId_fkey" FOREIGN KEY ("assignedAdminId") REFERENCES "admin_staff"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "audit_logs" ADD CONSTRAINT "audit_logs_actorId_fkey" FOREIGN KEY ("actorId") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;


import { IsString, IsOptional, IsEnum, IsObject } from 'class-validator';

export enum RequestType {
  TRANSLATION = 'translation',
  VISA = 'visa',
  HOUSING = 'housing',
  BANKING = 'banking',
}

export enum RequestPriority {
  NORMAL = 'normal',
  EXPRESS = 'express',
  EMERGENCY = 'emergency',
}

export class CreateRequestDto {
  @IsEnum(RequestType)
  type: RequestType;

  @IsOptional()
  @IsEnum(RequestPriority)
  priority?: RequestPriority;

  @IsOptional()
  @IsObject()
  details?: Record<string, any>;
}
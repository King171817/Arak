import { Test, TestingModule } from '@nestjs/testing';
import { AdminAdvancedService } from './admin-advanced.service';

describe('AdminAdvancedService', () => {
  let service: AdminAdvancedService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [AdminAdvancedService],
    }).compile();

    service = module.get<AdminAdvancedService>(AdminAdvancedService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});

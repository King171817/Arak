import { Test, TestingModule } from '@nestjs/testing';
import { AdminAdvancedController } from './admin-advanced.controller';

describe('AdminAdvancedController', () => {
  let controller: AdminAdvancedController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [AdminAdvancedController],
    }).compile();

    controller = module.get<AdminAdvancedController>(AdminAdvancedController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});

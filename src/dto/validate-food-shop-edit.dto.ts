import { IsBoolean, IsEnum, IsInt, IsString, Length, ValidateIf } from 'class-validator';

export class ValidateFoodShopEditDto {
  @IsInt()
  id: number;

  @IsBoolean()
  contract_status: boolean;

  @IsString()
  @Length(0, 50, {
    message: '50 文字以内で入力してください' // Please enter within 50 characters
  })
  shop_name: string;

  @IsEnum(['active', 'inactive', 'pending'], {
    message: 'Status must be either active, inactive, or pending'
  })
  status: string;
}

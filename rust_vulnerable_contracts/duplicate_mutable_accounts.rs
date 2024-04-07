use anchor_lang::prelude::*;

declare_id!("Fg6PaFpoGXkYsidMpWTK6W2BeZ7FEfcYkg476zPFsLnS");

#[program]
mod account_operations {
    use super::*;

    pub fn update_accounts(ctx: Context<AccountContext>, value_a: u64, value_b: u64) -> ProgramResult {
        ctx.accounts.account_one.update(value_a)?;
        ctx.accounts.account_two.update(value_b)?;
        Ok(())
    }
}

#[derive(Accounts)]
pub struct AccountContext<'info> {
    #[account(mut)]
    account_one: Account<'info, AccountInfo>,
    #[account(mut)]
    account_two: Account<'info, AccountInfo>,
}

#[account]
pub struct AccountInfo {
    data: u64,
}

impl AccountInfo {
    fn update(&mut self, new_value: u64) -> ProgramResult {
        self.data = new_value;
        Ok(())
    }
}

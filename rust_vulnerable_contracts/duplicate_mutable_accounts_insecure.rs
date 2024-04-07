use anchor_lang::prelude::*;

declare_id!("F1234567890123456789012345678901234567890");

#[program]
pub mod mutable_accounts {
    use super::*;

    pub fn update(ctx: Context<Update>, a: u64, b: u64) -> ProgramResult {
        let user_a = &mut ctx.accounts.user_a;
        let user_b = &mut ctx.accounts.user_b;

        user_a.data = a;
        user_b.data = b;
        Ok(())
    }
}

#[derive(Accounts)]
pub struct Update<'info> {
    #[account(mut)]
    user_a: Account<'info, User>,
    #[account(mut)]
    user_b: Account<'info, User>,
}

#[account]
pub struct User {
    data: u64,
}

https://github.com/coral-xyz/sealevel-attacks/tree/master/programs/6-duplicate-mutable-accounts
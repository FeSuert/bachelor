use anchor_lang::prelude::*;
use spl_token::state::Account as SplTokenAccount;

declare_id!("F1234567890123456789012345678901234567890");

#[program]
pub mod account_data {
    use super::*;

    pub fn log_message(ctx: Context<LogMessage>) -> ProgramResult {
        let token = SplTokenAccount::unpack(&ctx.accounts.token.data.borrow())?;
        msg!("Your account balance is: {}", token.amount);
        Ok(())
    }
}

#[derive(Accounts)]
pub struct LogMessage<'info> {
    // The token account being accessed
    token: AccountInfo<'info>,
    authority: Signer<'info>,
}

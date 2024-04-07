use anchor_lang::prelude::*;

declare_id!("F1234567890123456789012345678901234567890");

#[program]
pub mod signer_authorization {
    use super::*;

    pub fn log_message(ctx: Context<LogMessage>) -> ProgramResult {
        msg!("GM {}", ctx.accounts.authority.key().to_string());
        Ok(())
    }
}

#[derive(Accounts)]
pub struct LogMessage<'info> {
    authority: AccountInfo<'info>,
}

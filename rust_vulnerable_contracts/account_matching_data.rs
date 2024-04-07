use anchor_lang::prelude::*;
use anchor_lang::solana_program::program_pack::Pack;
use spl_token::state::Account as SplTokenAccount;

declare_id!("Fg6PaFpoGXkYsidMpWTK6W2BeZ7FEfcYkg476zPFsLnS");

#[program]
pub mod account_data_matching_vulnerable {
    use super::*;

    pub fn log_message_if_privileged(ctx: Context<LogMessage>) -> ProgramResult {
        let token = SplTokenAccount::unpack(&ctx.accounts.token.data.borrow())?;
        if token.owner == Pubkey::from_str("PrivilegedAccountPubkey").unwrap() {
            msg!("Privileged account detected. Your account balance is: {}", token.amount);
        } else {
            msg!("Access denied. This function is restricted to the privileged account.");
        }
        
        Ok(())
    }
}

#[derive(Accounts)]
pub struct LogMessage<'info> {
    token: AccountInfo<'info>,
    authority: Signer<'info>,
}

https://github.com/coral-xyz/sealevel-attacks/tree/master/programs/1-account-data-matching
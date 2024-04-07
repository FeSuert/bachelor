use anchor_lang::prelude::*;
use anchor_lang::solana_program::program_option::COption;
use anchor_lang::solana_program::program_error::ProgramError;

declare_id!("F1234567890123456789012345678901234567890");

#[error_code]
pub enum TokenError {
    #[msg("Invalid instruction")]
    InvalidInstruction,
}

#[program]
pub mod timely_state_reset {
    use super::*;

    pub fn change_owner_and_reset_state(ctx: Context<ChangeOwner>, new_owner: Pubkey) -> Result<()> {
        let account = &mut ctx.accounts.account_to_change;
        
        // Set the new owner of the account
        account.owner = new_owner;

        // Reset delegation and close authority for security
        account.delegate = COption::None;
        account.delegated_amount = 0;

        // Additionally, reset close authority if the account is native
        if account.is_native() {
            account.close_authority = COption::None;
        }

        Ok(())
    }
}

#[derive(Accounts)]
pub struct ChangeOwner<'info> {
    #[account(mut)]
    pub account_to_change: Account<'info, ManagedAccount>,
}

#[account]
pub struct ManagedAccount {
    pub owner: Pubkey,
    pub delegate: COption<Pubkey>,
    pub delegated_amount: u64,
    pub close_authority: COption<Pubkey>,
}

impl ManagedAccount {
    // Helper method to determine if an account is native
    fn is_native(&self) -> bool {
        // Assuming some logic to determine if the account is native
        // This could involve checking if the account's lamports are set to a specific state or value indicative of native accounts
        false
    }
}


// Recommendation:
// if let COption::Some(authority) = new_authority {
//     account.owner = authority;
// } else {
//     return Err(TokenError::InvalidInstruction.into());
// }

// account.delegate = COption::None;
// account.delegated_amount = 0;

// if account.is_native() {
//     account.close_authority = COption::None;
// }
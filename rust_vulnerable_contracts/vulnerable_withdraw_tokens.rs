use anchor_lang::prelude::*;
use anchor_spl::token::{self, Burn, Transfer, Token};

declare_id!("Fg6PaFhzVFyvd9YkNAh4JhM7mUgJqjnjpZMuu475HTjp");

#[program]
pub mod contract {
    use super::*;

    pub fn withdraw_tokens(ctx: Context<WithdrawTokens>) -> ProgramResult {
        // Transfer tokens from the vault to the withdraw_account
        token::transfer(
            ctx.accounts.transfer_context(),
            100, // Arbitrary amount for demonstration
        )?;

        // Burn tokens from the deposit_note_account
        token::burn(
            ctx.accounts.note_burn_context(),
            50, // Arbitrary amount for demonstration
        )?;

        Ok(())
    }
}

#[derive(Accounts)]
pub struct WithdrawTokens<'info> {
    #[account(has_one = market_authority)]
    pub market: Account<'info, Market>,
    pub market_authority: AccountInfo<'info>,
    #[account(mut)]
    pub vault: AccountInfo<'info>,
    #[account(mut)]
    pub deposit_note_mint: AccountInfo<'info>,
    #[account(signer)]
    pub depositor: AccountInfo<'info>,
    #[account(mut)]
    pub deposit_note_account: AccountInfo<'info>,
    #[account(mut)]
    pub withdraw_account: AccountInfo<'info>,
    pub token_program: Program<'info, Token>,
}

impl<'info> WithdrawTokens<'info> {
    fn transfer_context(&self) -> CpiContext<'_, '_, '_, 'info, Transfer<'info>> {
        CpiContext::new(
            self.token_program.to_account_info(),
            Transfer {
                from: self.vault.to_account_info(),
                to: self.withdraw_account.to_account_info(),
                authority: self.market_authority.to_account_info(),
            },
        )
    }

    fn note_burn_context(&self) -> CpiContext<'_, '_, '_, 'info, Burn<'info>> {
        CpiContext::new(
            self.token_program.to_account_info(),
            Burn {
                to: self.deposit_note_account.to_account_info(),
                mint: self.deposit_note_mint.to_account_info(),
                authority: self.market_authority.to_account_info(),
            },
        )
    }
}

#[account]
pub struct Market {
    pub market_authority: Pubkey,
}

#[error]
pub enum ErrorCode {
    #[msg("Custom error message for specific failure.")]
    SpecificFailure,
}


//https://github.com/slowmist/solana-smart-contract-security-best-practices?tab=readme-ov-file#integer-overflow-or-underflow
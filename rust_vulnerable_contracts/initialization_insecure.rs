use anchor_lang::prelude::*;
use borsh::{BorshDeserialize, BorshSerialize};

declare_id!("F1234567890123456789012345678901234567890");

#[program]
pub mod initialization_insecure {
    use super::*;

    pub fn initialize(ctx: Context<Initialize>) -> ProgramResult {
        let mut user = User::try_from_slice(&ctx.accounts.user.data.borrow()).unwrap();

        user.authority = ctx.accounts.authority.key();

        let mut storage = ctx.accounts.user.try_borrow_mut_data()?;
        user.serialize(&mut *storage)?;
        Ok(())
    }
}

#[derive(Accounts)]
pub struct Initialize<'info> {
    user: AccountInfo<'info>,
    authority: Signer<'info>,
}

#[derive(BorshSerialize, BorshDeserialize)]
pub struct User {
    authority: Pubkey,
}

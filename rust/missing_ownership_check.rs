use solana_program::{
    account_info::{AccountInfo, next_account_info},
    entrypoint::ProgramResult,
    pubkey::Pubkey,
    program_error::ProgramError,
    program_pack::{Pack, IsInitialized},
    msg,
};

// Represents a configuration for admin and fees
#[derive(Clone, Debug, PartialEq)]
pub struct Config {
    pub admin: Pubkey,
    pub fee: u32,
}

// Represents a user account
#[derive(Clone, Debug, PartialEq)]
pub struct User {
    pub user_authority: Pubkey,
    pub balance: u64,
}

impl IsInitialized for Config {
    fn is_initialized(&self) -> bool {
        true
    }
}

impl IsInitialized for User {
    fn is_initialized(&self) -> bool {
        true
    }
}

// Attempt to deserialize an account into a Config struct
fn unpack_config(account: &AccountInfo) -> Result<Config, ProgramError> {
    Config::unpack(&account.data.borrow())
        .or(Err(ProgramError::InvalidAccountData))
}

// The vulnerable withdraw function
fn withdraw_tokens(program_id: &Pubkey, accounts: &[AccountInfo], amount: u64) -> ProgramResult {
    let account_iter = &mut accounts.iter();
    // Supposedly a configuration account, but can be any account due to missing type check
    let config = next_account_info(account_iter)?;
    let verified_config = unpack_config(config)?;

    msg!("Admin pubkey: {:?}", verified_config.admin);
    // Further logic for withdrawal assuming `config` is valid...

    Ok(())
}

use solana_program::{
    account_info::{AccountInfo, next_account_info},
    pubkey::Pubkey,
    program_error::ProgramError,
    entrypoint::ProgramResult,
    program_pack::Pack,
};

// Account structures with distinct purposes
pub struct Config {
    pub TYPE: u8,
    pub admin: Pubkey,
    pub fee: u32,
    pub user_count: u32,
}

pub struct User {
    pub TYPE: u8,
    pub user_authority: Pubkey,
    pub balance: u64,
}

// Function vulnerable to account confusions due to type assumptions
fn withdraw_tokens(program_id: &Pubkey, accounts: &[AccountInfo], amount: u64) -> ProgramResult {
    let account_iter = &mut accounts.iter();
    let supposed_config = next_account_info(account_iter)?;
    let config: Config = Pack::unpack(&supposed_config.data.borrow())?;

    // Proceeds with withdrawal logic under incorrect assumptions about account type
    Ok(())
}

//Countermeasure

fn unpack_config(account: &AccountInfo) -> Result<Config, ProgramError> {
    let config: Config = Pack::unpack(&account.data.borrow())?;
    if config.TYPE != Types::ConfigType {
        return Err(ProgramError::InvalidAccountType);
    }
    Ok(config)
}

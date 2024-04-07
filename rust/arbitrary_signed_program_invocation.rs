use solana_program::{
    account_info::{AccountInfo, next_account_info},
    pubkey::Pubkey,
    program_error::ProgramError,
    entrypoint::ProgramResult,
    program::{invoke_signed},
};

// A vulnerable function intended to transfer tokens by invoking an external program
pub fn process_withdraw(program_id: &Pubkey, accounts: &[AccountInfo], amount: u64) -> ProgramResult {
    let account_info_iter = &mut accounts.iter();
    let vault = next_account_info(account_info_iter)?;
    let vault_authority = next_account_info(account_info_iter)?;
    let destination = next_account_info(account_info_iter)?;
    let token_program = next_account_info(account_info_iter)?;

    // Unverified invocation of the token program
    invoke_signed(
        &spl_token::instruction::transfer(
            &token_program.key,
            &vault.key,
            &destination.key,
            &vault_authority.key,
            &[&vault_authority.key],
            amount,
        )?,
        &[
            vault.clone(),
            destination.clone(),
            vault_authority.clone(),
            token_program.clone(),
        ],
        &[],
    )?;

    Ok(())
}


//Countermeasures 

// Verify that token_program is the official SPL Token program
if token_program.key != &spl_token::id() {
    return Err(ProgramError::InvalidTokenProgram);
}

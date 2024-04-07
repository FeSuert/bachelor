use solana_program::{
    account_info::{AccountInfo, next_account_info},
    declare_id,
    entrypoint,
    entrypoint::ProgramResult,
    msg,
    pubkey::Pubkey,
    sysvar::{instructions::Instructions, Sysvar},
};

// Declare the program's unique ID
declare_id!("F1234567890123456789012345678901234567890");

entrypoint!(process_instruction);

// Main entry point for the smart contract
fn process_instruction(
    program_id: &Pubkey, // The ID of the currently executing program
    accounts: &[AccountInfo], // The accounts passed to the program
    _instruction_data: &[u8], // Data passed to the program by the caller
) -> ProgramResult {
    let account_info_iter = &mut accounts.iter();

    let instruction_acc = next_account_info(account_info_iter)?;

    let current_instruction = Instructions::load_current_index(
        &instruction_acc.try_borrow_data()?,
    );

    msg!("Current instruction index: {}", current_instruction);

    Ok(())
}

// Note: The rest of the smart contract would contain additional logic for its specific use case,
//https://mp.weixin.qq.com/s/x39VlJM0tKQ7r8Xzzo25gQ
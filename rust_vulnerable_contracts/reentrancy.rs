use borsh::{BorshDeserialize, BorshSerialize};
use solana_program::{
    account_info::{next_account_info, AccountInfo},
    entrypoint,
    entrypoint::ProgramResult,
    pubkey::Pubkey,
    program::{invoke, invoke_signed},
    system_instruction,
};

#[derive(BorshSerialize, BorshDeserialize)]
pub struct TransferInstruction {
    pub amount: u64,
}

fn vulnerable_transfer_sol(
    program_id: &Pubkey,
    accounts: &[AccountInfo],
    instruction_data: &[u8],
) -> ProgramResult {
    let account_info_iter = &mut accounts.iter();
    let sender_account = next_account_info(account_info_iter)?;
    let receiver_account = next_account_info(account_info_iter)?;
    let callback_program_account = next_account_info(account_info_iter)?; // Added account for the callback

    let amount = TransferInstruction::deserialize(&mut instruction_data)?.amount;

    // Transfer instruction before state update or verification
    let transfer_instruction = system_instruction::transfer(
        sender_account.key,
        receiver_account.key,
        amount,
    );
    invoke(
        &transfer_instruction,
        &[
            sender_account.clone(),
            receiver_account.clone(),
        ],
    )?;


    let callback_instruction = system_instruction::transfer(
        receiver_account.key, 
        callback_program_account.key,
        1,
    );
    invoke_signed(
        &callback_instruction,
        &[receiver_account.clone(), callback_program_account.clone()],
        &[&[b"callback_seed".as_ref()]], 
    )?;

    Ok(())
}

entrypoint!(process_instruction);

fn process_instruction(
    program_id: &Pubkey,
    accounts: &[AccountInfo],
    instruction_data: &[u8],
) -> ProgramResult {
    vulnerable_transfer_sol(program_id, accounts, instruction_data)
}
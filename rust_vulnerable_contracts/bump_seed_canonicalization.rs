use borsh::{BorshDeserialize, BorshSerialize};
use solana_program::{
    account_info::{next_account_info, AccountInfo},
    entrypoint,
    entrypoint::ProgramResult,
    program::invoke_signed,
    program_error::ProgramError,
    pubkey::Pubkey,
    rent::Rent,
    system_instruction::create_account,
    sysvar::Sysvar,
};

#[derive(Debug, BorshDeserialize, BorshSerialize)]
pub enum MyInstruction {
    Create {amount: u64},
    Modify {amount: u64, new_amount: u64},
}

#[derive(Debug, BorshSerialize, BorshDeserialize)]
pub struct MyData {
    pub amount: u64,
}

entrypoint!(process_instruction);

fn process_instruction(
    program_id: &Pubkey,
    accounts: &[AccountInfo],
    mut instruction_data: &[u8],
) -> ProgramResult {

    match MyInstruction::deserialize(&mut instruction_data)? {
        MyInstruction::Create { amount } => create_acc(&program_id, &accounts, amount),
        MyInstruction::Modify { amount, new_amount } => modify_acc(&program_id, &accounts, amount, new_amount),
    }
}

pub fn create_acc(
    program_id: &Pubkey,
    accounts: &[AccountInfo],
    amount: u64,
) -> ProgramResult {

    let accounts_iter = &mut accounts.iter();
    let payer = next_account_info(accounts_iter)?;
    let data_account = next_account_info(accounts_iter)?;
    let system_program = next_account_info(accounts_iter)?;

    let bump = amount.to_le_bytes();

    let expected_address = Pubkey::create_program_address(
        &[&bump.as_ref()], program_id)?;

    if expected_address != *data_account.key {
        return Err(ProgramError::InvalidArgument);
    }

    invoke_signed(
        &create_account(
            &payer.key,
            &expected_address,
            Rent::get()?.minimum_balance(std::mem::size_of::<MyData>()),
            std::mem::size_of::<MyData>()
                .try_into()
                .map_err(|_| ProgramError::InsufficientFunds)?,
            &program_id,
        ),
        &[payer.clone(), data_account.clone(), system_program.clone()],
        &[&[ amount.to_le_bytes().as_ref()]],
    )?;

    let new_data = MyData {
        amount: amount,
    };

    new_data.serialize(&mut data_account.try_borrow_mut_data()?.as_mut())?;

    Ok(())
}

pub fn modify_acc(
    program_id: &Pubkey,
    accounts: &[AccountInfo],
    amount: u64,
    new_amount: u64,
) -> ProgramResult {
    let accounts_iter = &mut accounts.iter();
    let data_account = next_account_info(accounts_iter)?;
    let bump = amount.to_le_bytes();
    let expected_address = Pubkey::create_program_address(
        &[&bump.as_ref()], program_id)?;
    if expected_address != *data_account.key {
        return Err(ProgramError::InvalidArgument);
    }
    let new_data = MyData {
        amount: new_amount,
    };

    new_data.serialize(&mut data_account.try_borrow_mut_data()?.as_mut())?;
    Ok(())
}


https://github.com/El-Merovingio/solana-hacks/tree/main/bump-seed-canonicalization
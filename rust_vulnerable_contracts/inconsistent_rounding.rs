use borsh::{BorshDeserialize, BorshSerialize};
use solana_program::{
    account_info::{next_account_info, AccountInfo},
    entrypoint,
    entrypoint::ProgramResult,
    pubkey::Pubkey,
};


#[derive(Debug, BorshDeserialize, BorshSerialize)]
pub enum MyInstruction {
    Rounding {amount1: f64, amount2: f64},
}

#[derive(Debug, BorshSerialize, BorshDeserialize)]
pub struct MyData {
    pub amount: f64,
}

entrypoint!(process_instruction);

fn process_instruction(
    program_id: &Pubkey,
    accounts: &[AccountInfo],
    mut instruction_data: &[u8],
) -> ProgramResult {
    /* 
    This deserializes the instruction data into a MyInstruction enum and then matches 
        the variant to either call functions.
   */
    match MyInstruction::deserialize(&mut instruction_data)? {
        MyInstruction::Rounding { amount1, amount2 } => rounding(&program_id, &accounts, amount1, amount2),
    }
}

// Function 1: Arithmetics have rounding
pub fn rounding(
    _program_id: &Pubkey,
    accounts: &[AccountInfo],
    // instruction_data: &[u8],
    amount1: f64,f
    amount2: f64,
) -> ProgramResult {
    let account_info_iter = &mut accounts.iter();

    // Get the account that will hold the result
    let result_account = next_account_info(account_info_iter)?;

    // Compute the result as x/y
    let result = amount1 / amount2;

    // Save the result in new_data using the MyData Struct
    let new_data = MyData {
        amount: result,
    };

    new_data.serialize(&mut result_account.try_borrow_mut_data()?.as_mut())?;

    Ok(())
}



https://github.com/El-Merovingio/solana-hacks/tree/main/other-bugs
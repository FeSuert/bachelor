let FEE: u32 = 1000;

fn withdraw_token(program_id: &Pubkey, accounts: &[AccountInfo], amount: u32) -> ProgramResult {
    // Logic to deserialize and validate user and vault accounts

    if amount + FEE > vault.user_balance[user_id] {
        return Err(ProgramError::AttemptToWithdrawTooMuch);
    }
    // Proceed with the transfer of tokens
    Ok(())
}


//COUNTERMEASURE

if let Some(total) = amount.checked_add(FEE) {
    if total > vault.user_balance[user_id] {
        return Err(ProgramError::AttemptToWithdrawTooMuch);
    }
} else {
    return Err(ProgramError::InvalidArgument);
}

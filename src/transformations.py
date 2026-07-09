def apply_transformations(df, table_name):
    """
    Apply row-level business corrections.
    These corrections fix known source data issues.
    """

    if table_name == "payments":

        # Fix payment records by payment_id
        corrections = {

            # payment_id: {
            #     "reason": "...",
            #     "changes": {
            #         column: new_value
            #     }
            # }

            781: {
                "reason": "Incorrect counterpart_id and contract_id assigned in source data",
                "changes": {
                    "counterpart_id": 233,
                    "contract_id": 501,
                }
            },

            2693: {
                "reason": "Incorrect contract_id assigned in source data",
                "changes": {
                    "contract_id": 501,
                }
            },
        }

        print(df[df["payment_id"].isin([781, 2693])])


        for payment_id, correction in corrections.items():

            mask = df["payment_id"].astype("Int64") == payment_id
            
            print(
                payment_id,
                "rows found:",
                mask.sum()
                )

            if mask.any():

                for column, value in correction["changes"].items():
                    df.loc[mask, column] = value

                print(
                    f"Payment {payment_id} corrected: "
                    f"{correction['reason']}"
                )

            else:
                print(
                    f"WARNING: Payment {payment_id} not found. "
                    f"Correction skipped."
                )


    return df
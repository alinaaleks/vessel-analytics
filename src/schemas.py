schemas = {

    "projects": {
        "project_id": "Int64",
        "fobbing_plan": "float64",
        "export_tax_plan": "float64",
        "profit_plan": "float64",
        "cost_of_goods_plan": "float64",
        "price_ctr_manual": "float64",
    },


    "vessels": {
        "vessel_id": "Int64",
        "name": "string",
        "shipped_mt": "float64",
        "loading_port": "string",
        "loading_date": "datetime64[ns]",
        "discharge_port": "string",
        "project_id": "Int64",
    },


    "counterparts": {
        "counterpart_id": "Int64",
        "name": "string",
        "inn": "string",
        "org_type": "string",
    },


    "contract_types": {
        "contract_type_id": "Int64",
        "name": "string",
    },


    "contract_groups": {
        "contract_group_id": "Int64",
        "group_type": "string",
        "commodity": "string",
        "basis": "string",
        "loading_place": "string",
        "quality": "string",
        "needs_vessel_alloc": "boolean",
        "vessel_id": "Int64",
        "vessel_id_loose_manual": "Int64",
    },


    "contracts": {
        "contract_id": "Int64",
        "counterpart_id": "Int64",
        "date": "datetime64[ns]",
        "number": "string",
        "quantity_mt": "float64",
        "delivery_due_date": "datetime64[ns]",
        "total_by_ctr": "float64",
        "price_without_vat": "float64",
        "vat": "float64",
        "price_with_vat": "float64",
        "shipped_by_supplier_mt": "float64",
        "received_on_wh_mt": "float64",
        "contract_group_id": "Int64",
        "contract_type_id": "Int64",
    },


    "vessel_allocation": {
        "vessel_allocation_id": "Int64",
        "vessel_id": "Int64",
        "contract_id": "Int64",
        "quantity_allocated_mt": "float64",
        "quantity_planned_mt": "float64",
    },


    "payments": {
        "payment_id": "Int64",
        "internal_number": "string",
        "payment_date": "datetime64[ns]",
        "contract_id": "Int64",
        "counterpart_id": "Int64",
        "received_rub": "float64",
        "paid_rub": "float64",
        "operation_type": "string",
    }

}
import json

with open(r'c:\Users\jordi\TFG\notebooks\09_baselines.ipynb', 'r', encoding='utf-8') as f:
    nb = json.load(f)

for cell in nb['cells']:
    src = cell.get('source', [])
    if any('Regenerar predicciones para el scatter' in l for l in src):
        # Reset y_te to align with df_te (1757 rows) before generating predictions.
        # A previous cell overwrites y_te with y_test.npy (1750 rows from the
        # ML pipeline), causing a shape mismatch with df_te predictions.
        fix_line = "y_te = df_te['Consumo_kWh'].values  # realign with df_te\n"
        if fix_line not in src:
            cell['source'] = [fix_line, "\n"] + list(src)
        cell['outputs'] = []
        cell['execution_count'] = None
        print('Fixed: prepended y_te realignment to scatter cell')
        break

with open(r'c:\Users\jordi\TFG\notebooks\09_baselines.ipynb', 'w', encoding='utf-8') as f:
    json.dump(nb, f, ensure_ascii=False, indent=1)

print('Done.')

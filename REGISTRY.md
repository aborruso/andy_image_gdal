# GitHub Container Registry (GHCR) setup

Per poter pushare le immagini su `ghcr.io` dal workflow GitHub Actions, segui questi passi rapidi:

1. Preferibile: crea un Personal Access Token (PAT) con lo scope `write:packages`:
   - Vai su https://github.com/settings/tokens -> Generate new token
   - Seleziona `write:packages` (e opzionalmente `delete:packages` se servono)
   - Copia il token (non potrai rivederlo dopo)

2. Aggiungi il PAT come secret del repository:
   - Repo -> Settings -> Secrets and variables -> Actions -> New repository secret
   - Name: `GHCR_PAT`
   - Value: (incolla il token generato)

3. Controlla le impostazioni del repository/organization sulle GitHub Packages:
   - Se sei in un'organization, assicurati che Actions siano autorizzate a pubblicare pacchetti
   - Repo -> Settings -> Packages/Packages settings -> permetti publish da Actions

4. Fallback:
   - Se non vuoi usare un PAT, il workflow userà il `GITHUB_TOKEN` ma potresti dover modificare le policy della repo/organization.

5. Rilancia il workflow:
   - Dopo aver pushato le modifiche al workflow e aggiunto il secret, rilancia il job dalla pagina Actions.

Se vuoi, posso aggiungere queste istruzioni nel `README.md` e/o creare un commit che documenta il processo automaticamente.

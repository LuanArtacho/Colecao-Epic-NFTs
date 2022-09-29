// 🔒 Ver se conseguimos acessar a conta do usuário
// Então quando você rodar isso, você deve ver aquela linha "Temos o objeto ethereum" escrita no console do site quando você for inspecioná-lo. Se você estiver usando o Replit, tenha certeza que você está olhando para o console do site do projeto, e não o do Replit! Você pode acessar o console do seu site abrindo ele na sua própria aba e carregando as ferramentas de desenvolvedor. O URL deve se parecer com isso - https://nft-starter-project.seuUsuario.repl.co/

// BOA.

// Depois, nós precisamos checar se estamos autorizados mesmo a acessar a carteira do usuário. Uma vez que tivermos acesso a isso, podemos chamar nosso contrato inteligente.

// Basicamente, a Metamask não dá as credenciais da carteira para todo website que vamos. Ele apenas dá para sites que foram autorizados. De novo, é como fazer login! Mas, o que estamos fazendo aqui é checando se estamos logados.

// Cheque o código abaixo.

import React, { useEffect, useState } from "react";
import "./styles/App.css";
import twitterLogo from "./assets/twitter-logo.svg";
// Constantes
const TWITTER_HANDLE = "Web3dev_";
const TWITTER_LINK = `https://twitter.com/${TWITTER_HANDLE}`;
const OPENSEA_LINK = "";
const TOTAL_MINT_COUNT = 50;
const App = () => {
  /*
   * Só uma variável de estado que usamos pra armazenar nossa carteira pública. Não esqueça de importar o useState.
   */
  const [currentAccount, setCurrentAccount] = useState("");
  /*
   * Precisamos ter certeza que isso é assíncrono.
   */
  const checkIfWalletIsConnected = async () => {
    const { ethereum } = window;
    if (!ethereum) {
      console.log("Certifique-se que você tem metamask instalado!")
      return;
    } else {
      console.log("Temos o objeto ethereum!", ethereum)
    }
    /*
     * Checa se estamos autorizados a carteira do usuário.
     */
    const accounts = await ethereum.request({ method: "eth_accounts" });
    /*
     * Usuário pode ter múltiplas carteiras autorizadas, nós podemos pegar a primeira que está lá!
     */
    if (accounts.length !== 0) {
      const account = accounts[0];
      console.log("Encontrou uma conta autorizada:", account);
      setCurrentAccount(account);
    } else {
      console.log("Nenhuma conta autorizada foi encontrada");
    }
  };
  // Render Methods
  const renderNotConnectedContainer = () => (
    <button className="cta-button connect-wallet-button">
      Connect to Wallet
    </button>
  );
  useEffect(() => {
    checkIfWalletIsConnected();
  }, []);
  return (
    <div className="App">
      <div className="container">
        <div className="header-container">
          <p className="header gradient-text">Minha Coleção NFT</p>
          <p className="sub-text">
            Únicas. Lindas. Descubra a sua NFT hoje.
          </p>
          {renderNotConnectedContainer()}
        </div>
        <div className="footer-container">
          <img alt="Twitter Logo" className="twitter-logo" src={twitterLogo} />
          <a
            className="footer-text"
            href={TWITTER_LINK}
            target="_blank"
            rel="noreferrer"
          >{`built on @${TWITTER_HANDLE}`}</a>
        </div>
      </div>
    </div>
  );
};
export default App;
// 🌅 Usando window.ethereum()
// Então, para o nosso site conseguir falar com a blockchain, precisamos de alguma maneira conectar nossa carteira nele. Uma vez que conectarmos a carteira no site, ele vai ter a permissão para chamar contratos inteligentes no nosso nome. Lembre-se, é como ser autenticado para entrar em um site.

// Vá para o Replit e vá para App.js dentro de src, aqui é onde vamos estar fazendo todo trabalho.

// Se estivermos logados na Metamask, um objeto especial chamado ethereum será injetado dentro da nossa aba, que tem alguns métodos mágicos. 
// Vamos checar se temos isso primeiro.

import React, { useEffect } from "react";
import "./styles/App.css";
import twitterLogo from "./assets/twitter-logo.svg";
// Constants
const TWITTER_HANDLE = "Web3dev_";
const TWITTER_LINK = `https://twitter.com/${TWITTER_HANDLE}`;
const OPENSEA_LINK = "";
const TOTAL_MINT_COUNT = 50;
const App = () => {
  const checkIfWalletIsConnected = () => {
    /*
     * Primeiro tenha certeza que temos acesso a window.ethereum
     */
    const { ethereum } = window;
    if (!ethereum) {
      console.log("Certifique-se que você tem metamask instalado!");
      return;
    } else {
      console.log("Temos o objeto ethereum!", ethereum);
    }
  };
  // Métodos para Renderizar
  const renderNotConnectedContainer = () => (
    <button className="cta-button connect-wallet-button">
      Connect to Wallet
    </button>
  );
  /*
   * Isso roda nossa função quando a página carrega.
   */
  useEffect(() => {
    checkIfWalletIsConnected();
  }, []);
  return (
    <div className="App">
      <div className="container">
        <div className="header-container">
          <p className="header gradient-text">Minha Coleção NFT</p>
          <p className="sub-text">Exclusivos! Maravilhosos! Únicos! Descubra seu NFT hoje.</p>
          {/* adicione o seu render method aqui */}
          {renderNotConnectedContainer()}
        </div>
        <div className="footer-container">
          <img alt="Twitter Logo" className="twitter-logo" src={twitterLogo} />
          <a
            className="footer-text"
            href={TWITTER_LINK}
            target="_blank"
            rel="noreferrer"
          >{`feito com ❤️ pela @${TWITTER_HANDLE}`}</a>
        </div>
      </div>
    </div>
  );
};
export default App;
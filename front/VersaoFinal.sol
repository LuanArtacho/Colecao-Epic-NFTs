// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.1;

// Precisamos de algumas funcoes utilitarias.
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

// Precisamos importar essa funcao de base64 que acabamos de criar
import { Base64 } from "./libraries/Base64.sol";

contract MyEpicNFT is ERC721URIStorage {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  // Aqui esta o codigo do nosso SVG. So precisaremos alterar as palavras que vao ser exibidas. Todo o resto permanece igual.
  // Entao, fazemos uma variavel baseSvg aqui que todos os nossos NFTs vao usar.
  string baseSvg = "<svg  xmlns='http://www.w3.org/2000/svg'  preserveAspectRatio='xMinYMin meet'  viewBox='0 0 350 350'>  <defs>    <linearGradient id='Gradient1'>      <stop class='stop1' offset='0%'/>      <stop class='stop2' offset='50%'/>      <stop class='stop3' offset='100%'/>    </linearGradient>  </defs>  <style>    .base {      fill: blue;      font-family: serif;      font-size: 20px;      color: #FFF;    }    .stop1 { stop-color: green; }    .stop2 { stop-color: white; stop-opacity: 0; }    .stop3 { stop-color: yellow; }      </style>  <rect width='100%' height='100%' fill='url(#Gradient1)' />  <text    x='50%'    y='50%'    class='base'    dominant-baseline='middle'    text-anchor='middle'  >";

  // Eu crio tres listas, cada uma com seu grupo de palavras aleatorias
  // escolha as suas palavras divertidas, nome de personagem, comida, time de futebol, o que quiser! 
  string[] firstWords = ["Tubaina 1", "Guarana", "Fanta", "Doly", "Grapete"];
  string[] secondWords = ["Moqueca", "Feijoada", "Vatapa", "Acaraje", "Rabada", "Dobradinha"];
  string[] thirdWords = ["Maracuja", "Pitanga", "Graviola", "Acai", "Banana", "Amora"];
  event NewEpicNFTMinted(address sender, uint256 tokenId);

  constructor() ERC721 ("ChavesNFT", "CHAVO") {
    console.log("Meu contrato de NFT! Tchu-hu");
  }

  // Crio uma funcao que pega uma palavra aleatoria da lista.
  function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
    // Crio a 'semente' para o gerador aleatorio. Mais sobre isso na licao. 
    uint256 rand = random(string(abi.encodePacked("PRIMEIRA_PALAVRA", Strings.toString(tokenId))));
    // pego o numero no maximo ate o tamanho da lista, para nao dar erro de indice.
    rand = rand % firstWords.length;
    return firstWords[rand];
  }

  function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("SEGUNDA_PALAVRA", Strings.toString(tokenId))));
    rand = rand % secondWords.length;
    return secondWords[rand];
  }

  function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("TERCEIRA_PALAVRA", Strings.toString(tokenId))));
    rand = rand % thirdWords.length;
    return thirdWords[rand];
  }

  function random(string memory input) internal pure returns (uint256) {
      return uint256(keccak256(abi.encodePacked(input)));
  }

  function makeAnEpicNFT() public {
    uint256 newItemId = _tokenIds.current();

    // Agora pegamos uma palavra aleatoria de cada uma das 3 listas.
    string memory first = pickRandomFirstWord(newItemId);
    string memory second = pickRandomSecondWord(newItemId);
    string memory third = pickRandomThirdWord(newItemId);
    string memory combinedWord = string(abi.encodePacked(first, second, third));

    // Concateno tudo junto e fecho as tags <text> e <svg>.
    string memory finalSvg = string(abi.encodePacked(baseSvg, combinedWord, "</text></svg>"));

    // pego todos os metadados de JSON e codifico com base64.
    string memory json = Base64.encode(
        bytes(
            string(
                abi.encodePacked(
                    '{"name": "',
                    // Definimos aqui o titulo do nosso NFT sendo a combinacao de palavras.
                    combinedWord,
                    '", "description": "Uma colecao aclamada e famosa de NFTs maravilhosos.", "image": "data:image/svg+xml;base64,',
                    // Adicionamos data:image/svg+xml;base64 e acrescentamos nosso svg codificado com base64.
                    Base64.encode(bytes(finalSvg)),
                    '"}'
                )
            )
        )
    );

    // Assim como antes, prefixamos com data:application/json;base64
    string memory finalTokenUri = string(
        abi.encodePacked("data:application/json;base64,", json)
    );

    console.log("\n--------------------");
    console.log(finalTokenUri);
    console.log("--------------------\n");

    _safeMint(msg.sender, newItemId);
    
    // AQUI VAI A NOVA URI DINAMICAMENTE GERADA!!!
    _setTokenURI(newItemId, finalTokenUri);
  
    _tokenIds.increment();
    console.log("Um NFT com ID %s foi cunhado para %s", newItemId, msg.sender);
    emit NewEpicNFTMinted(msg.sender, newItemId);
  }
}

/*
*❌ Alerte o usuário quando ele estiver na rede errada.
Seu site apenas funcionará no Rinkeby (já que é onde reside o seu contrato).

Vamos adicionar uma boa mensagem informando os usuários sobre isso!

Para isso, fazemos uma solicitação RPC para a blockchain para ver o ID da chain à qual nossa carteira se conecta. (Por que uma chain e não uma rede? Boa pergunta!)

Já endereçamos solicitações ao blockchain. Usamos ethereum.request com os métodos eth_accounts e eth_requestAccounts. Agora usamos eth_chainId para obter o ID.

let chainId = await ethereum.request({ method: 'eth_chainId' });
console.log("Conectado à rede " + chainId);
// String, hex code of the chainId of the Rinkebey test network
const rinkebyChainId = "0x4"; 
if (chainId !== rinkebyChainId) {
	alert("Você não está conectado a rede Rinkeby de teste!");
}
Pronto, agora o usuário saberá se está na rede errada! A solicitação está em conformidade com o EIP-695, 
portanto, retorna o valor hexadecimal da rede como uma string. Você pode achar os IDs de outras redes aqui.



------- old MyEpicNft

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.1;
// Primeiro importamos alguns contratos do OpenZeppelin.
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";
// Nós herdamos o contrato que importamos. Isso significa que
// teremos acesso aos métodos do contrato herdado.
contract MyEpicNFT is ERC721URIStorage {
    // Mágica dada pelo OpenZeppelin para nos ajudar a observar os tokenIds.
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    // Nós precisamos passar o nome do nosso token NFT e o símbolo dele.
    constructor() ERC721 ("SquareNFT", "SQUARE"){
      console.log("Esse eh meu contrato de NFT! Tchu-hu");
    }
    // Uma função que o nosso usuário irá chamar para pegar sua NFT.
    function makeAnEpicNFT() public {
        // Pega o tokenId atual, que começa por 0.
        uint256 newItemId = _tokenIds.current();
        // Minta ("cunha") o NFT para o sender (quem ativa o contrato) usando msg.sender.
        _safeMint(msg.sender, newItemId);
        // Designa os dados do NFT.
        _setTokenURI(newItemId, "data:application/json;base64,ewogICJuYW1lIjogIlR1YmFpbmFNb3F1ZWNhTWFyYWN1amEiLAogICJkZXNjcmlwdGlvbiI6ICJVbSBORlQgc3VwZXIgZmFtb3NvIGRlIHVtYSBjb2xlw6fDo28gZGUgcXVhZHJhZG9zIiwKICAiaW1hZ2UiOiAiZGF0YTppbWFnZS9zdmcreG1sO2Jhc2U2NCxQSE4yWndvZ0lIaHRiRzV6UFNKb2RIUndPaTh2ZDNkM0xuY3pMbTl5Wnk4eU1EQXdMM04yWnlJS0lDQndjbVZ6WlhKMlpVRnpjR1ZqZEZKaGRHbHZQU0o0VFdsdVdVMXBiaUJ0WldWMElnb2dJSFpwWlhkQ2IzZzlJakFnTUNBek5UQWdNelV3SWdvK0NpQWdQR1JsWm5NK0NpQWdJQ0E4YkdsdVpXRnlSM0poWkdsbGJuUWdhV1E5SWtkeVlXUnBaVzUwTVNJK0NpQWdJQ0FnSUR4emRHOXdJR05zWVhOelBTSnpkRzl3TVNJZ2IyWm1jMlYwUFNJd0pTSXZQZ29nSUNBZ0lDQThjM1J2Y0NCamJHRnpjejBpYzNSdmNESWlJRzltWm5ObGREMGlOVEFsSWk4K0NpQWdJQ0FnSUR4emRHOXdJR05zWVhOelBTSnpkRzl3TXlJZ2IyWm1jMlYwUFNJeE1EQWxJaTgrQ2lBZ0lDQThMMnhwYm1WaGNrZHlZV1JwWlc1MFBnb2dJRHd2WkdWbWN6NEtJQ0E4YzNSNWJHVStDaUFnSUNBdVltRnpaU0I3Q2lBZ0lDQWdJR1pwYkd3NklHSnNZV05yT3dvZ0lDQWdJQ0JtYjI1MExXWmhiV2xzZVRvZ2MyVnlhV1k3Q2lBZ0lDQWdJR1p2Ym5RdGMybDZaVG9nTWpCd2VEc0tJQ0FnSUNBZ1kyOXNiM0k2SUNOR1JrWTdDaUFnSUNCOUNpQWdJQ0F1YzNSdmNERWdleUJ6ZEc5d0xXTnZiRzl5T2lCaWJIVmxPeUI5Q2lBZ0lDQXVjM1J2Y0RJZ2V5QnpkRzl3TFdOdmJHOXlPaUJ5WldRN0lITjBiM0F0YjNCaFkybDBlVG9nTURzZ2ZRb2dJQ0FnTG5OMGIzQXpJSHNnYzNSdmNDMWpiMnh2Y2pvZ2VXVnNiRzkzT3lCOUNpQWdJQ0FLSUNBOEwzTjBlV3hsUGdvZ0lEeHlaV04wSUhkcFpIUm9QU0l4TURBbElpQm9aV2xuYUhROUlqRXdNQ1VpSUdacGJHdzlJblZ5YkNnalIzSmhaR2xsYm5ReEtTSWdMejRLSUNBOGRHVjRkQW9nSUNBZ2VEMGlOVEFsSWdvZ0lDQWdlVDBpTlRBbElnb2dJQ0FnWTJ4aGMzTTlJbUpoYzJVaUNpQWdJQ0JrYjIxcGJtRnVkQzFpWVhObGJHbHVaVDBpYldsa1pHeGxJZ29nSUNBZ2RHVjRkQzFoYm1Ob2IzSTlJbTFwWkdSc1pTSUtJQ0ErQ2lBZ0lDQkNZVzVoYm1GTWFYaHBZVlJoYm1kbGNtbHVZUW9nSUR3dmRHVjRkRDRLUEM5emRtYysiCn0=");
        // Console.log para nos ajudar a ver qual NFT foi mintada e para quem
        console.log("Uma NFT com o ID %s foi mintada para %s", newItemId, msg.sender);
        // Incrementa o contador para quando o próximo NFT for mintado.
        _tokenIds.increment();
    }
}


*/
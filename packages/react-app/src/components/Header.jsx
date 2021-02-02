import React from "react";
import { PageHeader } from "antd";

export default function Header() {
  return (
    <a href="https://github.com/austintgriffith/scaffold-eth" target="_blank" rel="noopener noreferrer">
      <PageHeader
        title="tBTC Deposit Redemption Bounties"
        subTitle="built with 🏗 scaffold-eth"
        style={{ cursor: "pointer" }}
      />
    </a>
  );
}

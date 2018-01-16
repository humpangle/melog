import * as React from 'react';
import './App.css';

// tslint:disable-next-line:no-var-requires
const logo = require('./logo.svg');

class App extends React.Component {
  render() {
    return (
      <div className="App">
        <div className="App-header">
          <img src={logo} className="App-logo" alt="logo" />
          <h2>Melog</h2>
        </div>
        <p className="App-intro">Self discovery, one keystroke at a time.</p>
      </div>
    );
  }
}

export default App;

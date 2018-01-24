import * as React from "react";
import { Link, withRouter, RouteComponentProps } from "react-router-dom";
// import jss from "jss";
import NavigationBack from "material-ui/svg-icons/navigation/arrow-back";
import AppBar from "material-ui/AppBar";
import IconButton from "material-ui/IconButton";

// import { HEADER_BG_COLOR } from "../constants";
import { ROOT_URL, HEADER_BG_COLOR } from "../constants";

const logoSpinAnimationId = "App-logo-spin";

const styles = {
  header: {
    backgroundColor: HEADER_BG_COLOR,
    padding: "5px",
    color: "#fff"
  },

  logo: {
    animation: `${logoSpinAnimationId} infinite 20s linear`,
    height: "30px"
  },

  [`@keyframes ${logoSpinAnimationId}`]: {
    from: {
      transform: "rotate(0deg)"
    },

    to: {
      transform: "rotate(360deg)"
    }
  },
  title: {
    cursor: "pointer"
  }
};

// const { classes } = jss.createStyleSheet(styles).attach();

const renderTitle = (title: string) => (
  <span style={styles.title}>{title}</span>
);

const DefaultIconLeft = () => (
  <Link to={ROOT_URL}>
    <IconButton>
      <NavigationBack color="#fff" />
    </IconButton>
  </Link>
);

type HeaderProps = RouteComponentProps<{}> & {
  title?: string;
  iconLeft?: JSX.Element;
};

const header = ({
  title = "Melog",
  iconLeft = <DefaultIconLeft />,
  match: { url }
}: HeaderProps) => (
  <AppBar
    style={styles.header}
    title={renderTitle(title)}
    iconElementLeft={url === ROOT_URL ? <IconButton /> : iconLeft}
  />
);

export default withRouter(header);

// // tslint:disable-next-line:no-var-requires
// const logo = require("../logo.svg");

// const header = ({ title = "Melog", showLogo = false }) => (
//   <div className={`${classes.header}`}>
{
  /* <Link to={ROOT_URL}>
  {showLogo && <img src={logo} className={`${classes.logo}`} alt="logo" />}
</Link> */
}

//     <AppBar
//       title={renderTitle(title)}
//       // tslint:disable-next-line:jsx-no-multiline-js
//       iconElementLeft={
//         <IconButton>
//           <NavigationBack />
//         </IconButton>
//       }
//     />
//   </div>
// );

import React from "react"
import styled, { ThemeProvider } from "styled-components"

import colors from "../colors"
import textStyles from "../textStyles"
import ComponentParameterTemplate from "./ComponentParameterTemplate"

export default class ComponentParameterInstance extends React.Component {
  render() {


    let theme = {
      "view": { "normal": {} },
      "componentParameterTemplate": { "normal": {} }
    }
    return (
      <ThemeProvider theme={theme}>
        <div style={Object.assign({}, styles.view, {})}>
          <div style={Object.assign({}, styles.componentParameterTemplate, {})}>
            <ComponentParameterTemplate
              subtitleComponent={{"parameters":{"text":"Subtitle","textStyle":"subheading2"},"type":"Lona:Text"}}
              titleComponent={{"parameters":{"text":"Title","textStyle":"headline"},"type":"Lona:Text"}}

            />
          </div>
        </div>
      </ThemeProvider>
    );
  }
};

let styles = {
  view: {
    alignItems: "flex-start",
    display: "flex",
    flex: "1 1 0%",
    flexDirection: "column"
  },
  componentParameterTemplate: {
    alignItems: "flex-start",
    display: "flex",
    flex: "0 0 auto",
    flexDirection: "row"
  }
}
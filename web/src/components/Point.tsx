import React, { useState, useEffect } from "react";
import styles from "./modules/Point.module.css";
import { PointData } from "./App";
import { MdPlace } from "react-icons/md";
import { fetchNui } from "../utils/fetchNui";

const App: React.FC<{ data: PointData }> = ({ data }) => {
  const [selectedIndex, setSelectedIndex] = useState(0);

  const updateOption = (opt: string) => {
    const newIndex =
      opt === "up" ? (selectedIndex === 0 ? data.options.length - 1 : selectedIndex - 1) : (selectedIndex + 1) % data.options.length;
    setSelectedIndex(newIndex);
  };

  const setSelectedIndexClient = (index: number) => {
    fetchNui<number>("setSelectedIndexClient", index).then(() => {}).catch(() => {});
  };

  const handleKeyPress = (event: KeyboardEvent) => {
    if (data.active) {
      if (event.key === "ArrowUp" || event.key === "ArrowDown") {
        updateOption(event.key === "ArrowUp" ? "up" : "down");
      } else if (event.key === "e") {
        setSelectedIndexClient(selectedIndex);
      }
    }
  };

  const handleWheel = (event: WheelEvent) => {
    updateOption(event.deltaY < 0 ? "up" : "down");
  };

  useEffect(() => {
    window.addEventListener("keydown", handleKeyPress);
    window.addEventListener("wheel", handleWheel, { passive: true });

    return () => {
      window.removeEventListener("keydown", handleKeyPress);
      window.removeEventListener("wheel", handleWheel);
    };
  }, [data.active, selectedIndex]);

  return (
    <div
      tabIndex={0}
      style={{
        ...data.pos,
        width: data.active ? "6rem" : "3rem",
        fontSize: data.active ? "2.5rem" : "0.1rem",
        visibility: data.show ? "visible" : "hidden",
      }}
      className={styles.container}
    >
      {data.active ? (
        <>
          <div className={styles.ButtonLetter}>
            <MdPlace size={24} style={{ color: "#1E90FF" }} />
          </div>
          <div className={styles.pointText}>
            <ul>
              {data.options.map((item, index) => (
                <li
                  key={index}
                  className={index === selectedIndex ? styles.selectedItem : ""}
                >
                  {item.text}
                </li>
              ))}
            </ul>
          </div>
        </>
      ) : (
        <MdPlace size={24} className={styles.dot} />
      )}
    </div>
  );
};

export default App;